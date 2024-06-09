# frozen_string_literal: true

module ActiveRecord
  module Metadata
    class Schema
      attr_reader :metadata

      def initialize
        @metadata = StorageManager.reloaded_metadata
      end

      def tag_value(database_name, table_name, column_name, tag_name)
        metadata.dig(database_name, table_name, Constants::COLUMNS_KEY, column_name, Constants::TAGS_KEY, tag_name)
      end

      def tagged?(database_name, table_name, column_name, tag_name, tag_value)
        tag_value(database_name, table_name, column_name, tag_name) == tag_value
      end

      def update_tag(database_name, table_name, column_name, tag_name, value)
        tags_hash = metadata.dig(database_name, table_name, Constants::COLUMNS_KEY, column_name, Constants::TAGS_KEY)
        if tags_hash.nil? || !tags_hash.key?(tag_name)
          error_message = "MISSING TAG OR COLUMN for: #{database_name}.#{table_name}.#{column_name}.#{tag_name}"
          raise ActiveRecord::Metadata::Error, error_message
        end

        tags_hash[tag_name] = value
        save
      end

      # Saves the current metadata.
      def save
        validate
        StorageManager.update(Utils.deep_sort_hash(metadata))
      end

      def process_metadata(&block)
        metadata.each(&block)
      end

      def process_tables
        process_metadata do |database_name, tables|
          tables.each do |table_name, table_value|
            yield(database_name, table_name, table_value)
          end
        end
      end

      def process_columns
        process_tables do |database_name, table_name, table_value|
          table_value[Constants::COLUMNS_KEY].each do |column_name, column_value|
            yield(database_name, table_name, column_name, column_value)
          end
        end
      end

      def process_tags
        process_columns do |database_name, table_name, column_name, column_value|
          column_value[Constants::TAGS_KEY].each do |tag_name, tag_value|
            yield(database_name, table_name, column_name, tag_name, tag_value)
          end
        end
      end

      private

      def validate
        process_tags do |database_name, table_name, column_name, tag_name, tag_value|
          process_tag_message = "#{database_name}.#{table_name}.#{column_name}.#{tag_name}"
          next if ActiveRecord::Metadata.config.tag_undefined_value == tag_value
          next if ActiveRecord::Metadata.config.tag_allowed_values(tag_name).include?(tag_value)
          next if ActiveRecord::Metadata.config.default_tag_allowed_values&.include?(tag_value)

          error_message = "#{process_tag_message} CAN NOT BE #{tag_value}"
          raise ActiveRecord::Metadata::Error, error_message
        end
      end
    end
  end
end
