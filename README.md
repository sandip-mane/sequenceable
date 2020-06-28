# Sequenceable

[![sandip-mane](https://circleci.com/gh/sandip-mane/sequenceable.svg?style=svg)](https://app.circleci.com/pipelines/github/sandip-mane/sequenceable?branch=master)

Adds sequencing abilities to the ActiveRecord Models.
This gem can be useful in managing `sequence` of the records in the database.

The `sequence` will be auto-generated, when the records are created.

## Usage

### Install

```ruby
gem 'sequenceable'
```

```ruby
bundle
```

### Create Migration

```ruby
bin/rails generate migration AddSequenceTo{MODEL_NAME} sequence:integer
```

### Enable Sequencing

By default, `acts_in_sequence` assumes the records sequence is stored in `sequence` column of type `integer`.

```ruby
class Task < ActiveRecord::Base
  acts_in_sequence
end
```

#### :scope
This attribute allows us to track sequencing with a scope.

```ruby
class TodoList < ActiveRecord::Base
  has_many :tasks
end

class Task < ActiveRecord::Base
  acts_in_sequence scope: :todo_list

  belongs_to :todo_list
end
```

#### :column_name
With `:column_name` we can use custom column names instead of using `sequence`.

```ruby
class Task < ActiveRecord::Base
  acts_in_sequence column_name: :display_order
end
```

#### :default_order
When sequencing is applied, records will be sorted with `ASC` sequence by default. Use `default_order` attribute to change it when you need to.
Use scope `without_sequence_order` when you want to remove the default ordering.

```ruby
class Task < ActiveRecord::Base
  acts_in_sequence
end

class Item < ActiveRecord::Base
  acts_in_sequence default_order: :desc
end

Task.all                        # => 1, 2, 3, 4, 5
Item.all                        # => 5, 4, 3, 2, 1
Item.without_sequence_order.all # => 1, 2, 3, 4, 5
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sandip-mane/sequenceable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sequenceable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sandip-mane/sequenceable/blob/master/CODE_OF_CONDUCT.md).
