# frozen_string_literal: true

require 'tty-prompt'

module ActiveRecord
  module Metadata
    class CI
      attr_reader :schema

      def initialize
        @schema = Schema.new
      end

      def prompt
        schema.process_tables do |database_name, table_name, table_value|
          next unless includes_undefined_values?(table_value)

          Logger::Table.log_data(table_value[Constants::MODEL_KEY].constantize)

          table_value[Constants::COLUMNS_KEY].each do |column_name, column|
            column[Constants::TAGS_KEY].each do |tag_name, tag_value|
              next unless tag_value == Constants::DEFAULT_TAG_UNDEFINED_VALUE

              ask_user_about_pending_tag(database_name, table_name, column_name, tag_name)
            end
          end
        end
      end

      private

      def includes_undefined_values?(table_value)
        table_value[Constants::COLUMNS_KEY].any? do |_, column_value|
          column_value[Constants::TAGS_KEY].value?(Constants::DEFAULT_TAG_UNDEFINED_VALUE)
        end
      end

      def ask_user_about_pending_tag(database_name, table_name, column_name, tag_name)
        prompt = TTY::Prompt.new(active_color: :cyan)

        prompt.select(
          "Is the column #{Pastel.new.red(column_name)} a #{tag_name.humanize} column?",
          prompt_choices(database_name, table_name, column_name, tag_name)
        )
      end

      def prompt_choices(database_name, table_name, column_name, tag_name)
        choices = ActiveRecord::Metadata.config.tag_allowed_values(tag_name).each_with_object({}) do |value, hash|
          hash[value] = -> { schema.update_tag(database_name, table_name, column_name, tag_name, value) }
        end

        choices['skip'] = -> {}
        choices['exit'] = -> { exit }
        choices
      end
    end
  end
end
