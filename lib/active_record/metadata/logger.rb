# frozen_string_literal: true

require 'tty-table'
require 'pastel'

module ActiveRecord
  module Metadata
    module Logger
      module Table
        FAILURE_SYMBOL = '✗'
        SUCCESS_SYMBOL = '✓'

        def self.log_data(model)
          tty_table = TTY::Table.new(
            header: create_header,
            rows: table_rows(model)
          )
          puts "Data for table <#{format_name(model.table_name)}>"
          puts tty_table.render(:ascii, padding: [0, 1])
        end

        def self.create_header
          ['  ', 'Name', 'Type'] + ActiveRecord::Metadata.config.tags.map(&:humanize)
        end

        def self.table_rows(model)
          model.columns.map do |column|
            data = [
              column.name,
              column.type
            ] + ActiveRecord::Metadata.config.tags.map do |tag|
              model.column_tag_value(column.name, tag)
            end
            format_row(data, column_undefined?(data))
          end
        end

        def self.column_undefined?(data)
          data.include?(':FIXME')
        end

        def self.format_row(data, failure)
          row_data = failure ? data.map { |d| format_failure(d) } : data
          [failure ? FAILURE_SYMBOL : SUCCESS_SYMBOL] + row_data
        end

        def self.format_failure(data)
          Pastel.new.red(data.to_s)
        end

        def self.format_name(name)
          Pastel.new.green(name)
        end
      end
    end
  end
end
