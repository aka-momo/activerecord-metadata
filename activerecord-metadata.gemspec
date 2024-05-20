# frozen_string_literal: true

require_relative 'lib/active_record/metadata/version'

Gem::Specification.new do |spec|
  spec.name = 'activerecord-metadata'
  spec.version = ActiveRecord::Metadata::VERSION
  spec.authors = ['Mohamed Motaweh']
  spec.email = ['akamomo.dev@gmail.com']

  spec.summary = 'Annotate your activerecord models'
  spec.description = 'Tag columns and tables'
  spec.homepage = 'https://github.com/aka-momo/activerecord-metadata'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['allowed_push_host'] = 'https://github.com/aka-momo/activerecord-metadata'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/aka-momo/activerecord-metadata'
  spec.metadata['changelog_uri'] = 'https://github.com/aka-momo/activerecord-metadata/CHANGELOG.md'

  spec.files = Dir['CHANGELOG.md', 'LICENSE', 'README.md', 'lib/**/*', 'sig/**/*']
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.metadata['rubygems_mfa_required'] = 'true'
end
