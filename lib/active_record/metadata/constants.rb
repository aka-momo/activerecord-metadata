# frozen_string_literal: true

module ActiveRecord
  module Metadata
    class Constants
      # Configuration defaults
      DEFAULT_METADATA_FILE_PATH_PREFIX = 'db'
      DEFAULT_METADATA_FILE_NAME        = 'schema_metadata'
      DEFAULT_METADATA_FILE_FORMAT      = 'yaml'
      DEFAULT_TAG_UNDEFINED_VALUE       = ':FIXME'
      DEFAULT_TAG_ALLOWED_VALUES        = [true, false].freeze
      TAGS_ALLOWED_VALUES               = {}.freeze

      # Internal Constants
      COLUMNS_KEY = 'columns'
      MODEL_KEY   = 'model_name'
      TYPE_KEY    = 'type'
      TAGS_KEY    = 'tags'
    end
  end
end
