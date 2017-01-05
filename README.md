# PureValidator [![Build Status](https://travis-ci.org/AlbertGazizov/pure_validator.png)](https://travis-ci.org/AlbertGazizov/pure_validator) [![Code Climate](https://codeclimate.com/github/ddd-ruby/pure_validatorbadges/gpa.svg)](https://codeclimate.com/github/ddd-ruby/pure_validator)


PureValidator is simple library for validating ruby objects.
The main idea of the gem is separate all object validation logic from the object itself

## Usage
Lets say you have the following class and you wan to validate objects of this class
```ruby
class Contact
  attr_accessor :first_name, :last_name, :position, :age, :type, :email, :color, :status, :stage, :description, :companies
end
```
To validate objects of the Contact class define a validator:
```ruby
class ContactValidator
  include PureValidator::Validator

  validates :first_name, presence: true, length: { min: 4, max: 7 }
  validates :last_name,  length: { equal_to: 5 }
  validates :position,   length: { not_equal_to: 5 }
  validates :age,        numericality: { greater_than: 0, less_than: 150 }
  validates :type,       numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :email,      email: true
  validates :color,      regexp: /#\w{6}/
  validates :status,     inclusion: { in: [:new, :lead] }
  validates :stage,      exclusion: { in: [:wrong, :bad] }

  validate_associated :companies, validator: CompanyValidator

  validate :check_description

  def check_description(entity, errors)
    if entity.description.nil?
      errors.add(:description, "can't be empty")
    end
  end
end
```

Instantiate the validator and pass a contact object inside:
```ruby
errors = ContactValidator.new.validate(contact)
```
errors is a hash which contains all validation errors
if object is valid then errors will be empty

### Adding own validators
PureValidator can be extended by adding your own validators.
To add a validator define a class with two the class method validate and validate_options:
The following example demonstrates the built in inclusion validator,
it validates that specified value is one of the defined value
```ruby
class PureValidator::Validators::InclusionValidator

  # Validates that given value inscluded in the specified list
  # @param value [Object] object to validate
  # @parm options [Hash] validation options, e.g. { in: [:small, :medium, :large], message: "not included in the list of allowed items" }
  #                      where :in - list of allowed values,
  #                      message - is a message to return if value is not included in the list
  # @return [Array] empty array if object is valid, list of errors otherwise
  def self.validate(value, options)
    return [] if value.nil?

    errors = []
    if options[:in]
      unless options[:in].include?(value)
        errors << (options[:message] || PureValidator::I18n.t('errors.should_be_included_in_list', list: options[:in]))
      end
    end
    errors
  end

  # Validates that options specified in
  # :inclusion are valid
  def self.validate_options(options)
    raise ArgumentError, "validation options should be a Hash" unless options.is_a?(Hash)
    raise ArgumentError, "validation options should have :in option and it should be an array of allowed values" unless options[:in].is_a?(Array)
  end

end
```
And register it in PureValidator:
```ruby
PureValidator.add_validator(:inclusion,    PureValidator::Validators::InclusionValidator)
```
Now you can use it:
```ruby
class SomeValidator
  include PureValidator::Validator

  validates :size, inclusion: { in: [:small, :medium, :large] }
end
```

## Installation

Add this line to your application's Gemfile:

    gem 'pure_validator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pure_validator

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO
1. Document methods

## Author
Albert Gazizov, [@deeper4k](https://twitter.com/deeper4k)
