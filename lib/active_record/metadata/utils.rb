# frozen_string_literal: true

module ActiveRecord
  module Metadata
    module Utils
      # Recursively sorts the keys of a hash.
      def self.deep_sort_hash(hash)
        sorted_hash = hash.sort_by { |key, _value| key.to_s }.to_h
        sorted_hash.each do |key, value|
          sorted_hash[key] = deep_sort_hash(value) if value.is_a?(Hash)
        end
        sorted_hash
      end
    end
  end
end
