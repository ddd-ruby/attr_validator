class PureValidator::Validators::NumericalityValidator

  # Validates that +number+ satisfies all validation rules defined in +options+
  # @param number  [Numeric] number to validate
  # @param options [Hash]    validation rules
  # @return [Array] empty array if number is valid, array of error messages otherwise
  def self.validate(number, options)
    self.new(number, options).validate
  end

  def self.validate_options(options)
    PureValidator::ArgsValidator.is_hash!(options, :validation_rule)
    PureValidator::ArgsValidator.has_only_allowed_keys!(options, [
      :greater_than, :greater_than_or_equal_to, :less_than, :less_than_or_equal_to, :even, :odd
    ], :validation_rule)
  end

  attr_accessor :object, :options, :errors
  def initialize(object, options)
    @object, @options = object, options
    @errors = []
  end

  def validate
    return errors if object.nil?

    handle_compare(:greater_than, :<=, 'errors.should_be_greater_than')
    handle_compare(:greater_than_or_equal_to, :<, 'errors.should_be_greater_than_or_equal_to')
    handle_compare(:less_than, :>=, 'errors.should_be_less_than')
    handle_compare(:less_than_or_equal_to, :>, 'errors.should_be_less_than_or_equal_to')
    handle_condition(:even, :even?, 'errors.should_be_even')
    handle_condition(:odd, :odd?, 'errors.should_be_odd')

    errors
  end

  def handle_compare(key, condition, error_key)
    return unless options[key]
    if object.send(condition, options[key])
      add_error!(error_key, options[key])
    end
  end

  def handle_condition(key, condition, error_key)
    return unless options[key]
    unless object.send(condition)
      add_error!(error_key)
    end
  end

  def add_error!(key, number=nil)
    if number
      errors << PureValidator::I18n.t(key, number: number)
    else
      errors << PureValidator::I18n.t(key)
    end
  end
end
