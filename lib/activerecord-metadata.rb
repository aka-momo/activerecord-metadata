# frozen_string_literal: true

require 'rails'
require 'rails/railtie'

module ActiveRecord
  module Metadata
    class Railtie < Rails::Railtie
      railtie_name :activerecord_metadata

      rake_tasks do
        load 'tasks/metadata_tasks.rake'
      end
    end
  end
end
