# frozen_string_literal: true

namespace :activerecord_metadata do
  desc 'Export DB + Stored Schema Metadata'
  task export: :environment do
    ActiveRecord::Metadata::Schema.new.save
  end

  desc 'Prompt to fill tag values'
  task ci: :environment do
    ActiveRecord::Metadata::CI.new.prompt
  end
end
