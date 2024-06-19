# ActiveRecord::Metadata

⚠️ This project is under development

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add activerecord-metadata

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install activerecord-metadata

## Configuration

```ruby
ActiveRecord::Metadata.configure do |config|
  # Default config.tags = []
  config.tags = %w[personal_data senstive_data]

  # Default config.models = []
  config.models = proc {
    Rails.application.eager_load!

    ApplicationRecord.descendants.reject do |model|
      model.table_name.blank? || model.superclass != ApplicationRecord
    end
  }

  # Default config.tag_default_rules = nil
  config.tag_default_rules = lambda { |column, tag|
    string_column = %w[text string jsonb json].include?(column.type.to_s)

    case tag
    when 'personal_data', 'senstive_data'
      string_column ? config.tag_undefined_value : false
    end
  }

  # Default config.tags_allowed_values = {}
  config.tags_allowed_values = {
    'personal_data' => [true, false, 'notsure']
  }

  # Default config.metadata_file_path_prefix = 'db'
  # config.metadata_file_path_prefix

  # Default config.metadata_file_name = 'schema_metadata'
  # config.metadata_file_name

  # Default config.metadata_file_format = 'yaml'
  # config.metadata_file_format

  # Default config.tag_undefined_value = ":FIXME"
  # config.tag_undefined_value

  # Default config.default_tag_allowed_values = [true, false]
  # config.default_tag_allowed_values
end
```

## Usage

#### (Re)generate Schema Metadata
The following command fetches the updated database schema to update the annotation file
```
rake activerecord_metadata:export
```

#### Trigger the interactive CI to start updating your metadata
```
rake activerecord_metadata:ci
```
<img width="1309" alt="image" src="https://github.com/aka-momo/activerecord-metadata/assets/1743388/29b72ffb-df22-4509-8e84-3db72d0055e2">


Check the column is tag value
```ruby
# User.column_tag_value(column_name, tag_name)
User.column_tag_value('first_name', 'personal_data')
# Returns the value of the tag (true, false, etc...)
```

Check if the column is tagged
```ruby
# User.column_tagged?(column_name, tag_name, tag_value)
User.column_tagged?('first_name', 'personal_data', true)
# Returns if the value matches true
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aka-momo/activerecord-metadata. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/aka-momo/activerecord-metadata/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveRecord::Metadata project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aka-momo/activerecord-metadata/blob/main/CODE_OF_CONDUCT.md).
