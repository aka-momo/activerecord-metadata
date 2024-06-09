# frozen_string_literal: true

require 'rails'
require 'active_record'
require_relative 'metadata/version'
require_relative 'metadata/constants'
require_relative 'metadata/config'
require_relative 'metadata/utils'
require_relative 'metadata/storage_manager'
require_relative 'metadata/schema'
require_relative 'metadata/ci'
require_relative 'metadata/methods'
require_relative 'metadata/logger'

module ActiveRecord
  module Metadata
    class Error < StandardError; end

    def self.config
      @config ||= ActiveRecord::Metadata::Config.new
    end

    def self.configure
      yield(config)
    end
  end
end
