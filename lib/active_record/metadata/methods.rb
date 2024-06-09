# frozen_string_literal: true

module ActiveRecord
  module Metadata
    module Methods
      def column_tag_value(column_name, tag_name)
        ActiveRecord::Metadata::Schema.new.tag_value(connection_db_config.name, table_name, column_name, tag_name)
      end

      def column_tagged?(column_name, tag_name, tag_value)
        ActiveRecord::Metadata::Schema.new.tagged?(connection_db_config.name, table_name, column_name, tag_name,
                                                   tag_value)
      end
    end
  end
end

ActiveRecord::Base.extend(ActiveRecord::Metadata::Methods)
