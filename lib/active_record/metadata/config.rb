# frozen_string_literal: true

require 'rails'

module ActiveRecord
  module Metadata
    class Config
      attr_accessor :metadata_file_path_prefix, :metadata_file_name, :metadata_file_format, :tag_default_rules,
                    :tag_undefined_value, :tags_allowed_values, :default_tag_allowed_values, :models, :tags

      def initialize
        @tags = []
        @metadata_file_path_prefix  = Constants::DEFAULT_METADATA_FILE_PATH_PREFIX
        @metadata_file_name         = Constants::DEFAULT_METADATA_FILE_NAME
        @metadata_file_format       = Constants::DEFAULT_METADATA_FILE_FORMAT
        @tag_undefined_value        = Constants::DEFAULT_TAG_UNDEFINED_VALUE
        @default_tag_allowed_values = Constants::DEFAULT_TAG_ALLOWED_VALUES
        @tags_allowed_values        = Constants::TAGS_ALLOWED_VALUES
      end

      def tag_default_value(column, tag)
        value = tag_default_rules&.call(column, tag)

        return tag_undefined_value if value.nil?

        value
      end

      def tag_allowed_values(tag_name)
        tags_allowed_values[tag_name] || default_tag_allowed_values
      end

      def _models
        models&.call || []
      end

      def metadata_file_path
        Rails.root.join(metadata_file_path_prefix, "#{metadata_file_name}.#{metadata_file_format}")
      end
    end
  end
end
