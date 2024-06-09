# frozen_string_literal: true

require 'json'
require 'yaml'

module ActiveRecord
  module Metadata
    module StorageManager
      def self.reloaded_metadata
        Utils.deep_sort_hash merge_hashes(stored_metadata, raw_metadata)
      end

      def self.update(data)
        File.write(ActiveRecord::Metadata.config.metadata_file_path, format_class.dump(data))
      end

      def self.exists?
        File.exist?(ActiveRecord::Metadata.config.metadata_file_path)
      end

      def self.format_class
        ActiveRecord::Metadata.config.metadata_file_format == 'yaml' ? YAML : JSON
      end

      def self.stored_metadata
        return unless exists?

        format_class.load_file(ActiveRecord::Metadata.config.metadata_file_path)
      end

      def self.raw_metadata
        result = {}
        ActiveRecord::Metadata.config._models.each do |m|
          result[m.connection_db_config.name] ||= {}
          result[m.connection_db_config.name][m.table_name] = {
            Constants::MODEL_KEY => m.name,
            Constants::COLUMNS_KEY => raw_columns(m)
          }
        end
        result
      end

      def self.raw_columns(model)
        model.columns_hash.transform_values do |column|
          {
            Constants::TYPE_KEY => column.type.to_s,
            Constants::TAGS_KEY => ActiveRecord::Metadata.config.tags.each_with_object({}) do |tag_name, tags_hash|
              tags_hash[tag_name] = ActiveRecord::Metadata.config.tag_default_value(column, tag_name)
            end
          }
        end
      end

      def self.merge_hashes(stored_metadata, raw_metadata)
        return raw_metadata if stored_metadata.blank?

        # Merge both stored_metadata and raw_metadata keys
        all_db_names = (stored_metadata.keys + raw_metadata.keys).uniq

        all_db_names.each_with_object({}) do |db_name, merged_hash|
          stored_tables = stored_metadata[db_name] || {}
          raw_tables = raw_metadata[db_name] || {}

          # Merge tables for the current database
          merged_hash[db_name] = merge_tables(stored_tables, raw_tables)
        end
      end

      def self.merge_tables(stored_tables, raw_tables)
        # Keep raw_tables keys
        raw_tables.keys.each_with_object({}) do |table_name, merged_table|
          stored_table_data = stored_tables[table_name] || {}
          raw_table_data = raw_tables[table_name] || {}

          # Merge columns for the current table
          merged_table[table_name] = {
            Constants::MODEL_KEY => raw_table_data[Constants::MODEL_KEY],
            Constants::COLUMNS_KEY => merge_columns(stored_table_data[Constants::COLUMNS_KEY] || {},
                                                    raw_table_data[Constants::COLUMNS_KEY] || {})
          }
        end
      end

      def self.merge_columns(stored_columns, raw_columns)
        # Merge columns from raw_metadata into stored_metadata
        merged_columns = raw_columns.merge(stored_columns) do |_column_name, raw_data, stored_data|
          # Merge tags for the current column deeply
          merged_tags = (raw_data[Constants::TAGS_KEY] || {}).deep_merge(stored_data[Constants::TAGS_KEY] || {})

          # # Merge other fields for the current column (like column type)
          stored_data.merge(Constants::TAGS_KEY => merged_tags,
                            Constants::TYPE_KEY => raw_data[Constants::TYPE_KEY] || stored_data[Constants::TYPE_KEY])
        end

        # Filter out columns that are not present in raw_metadata
        merged_columns.reject { |column_name, _data| raw_columns[column_name].nil? }
      end
    end
  end
end
