class PureValidator::Validators::LengthValidator

  # Validates that given object has correct length
  # @param object [#length] object to validate
  # @param options [Hash] validation options, e.g. { min: 2, max: 4, equal_to: 3, not_equal_to: 6 }
  # @return [Array] empty array if object is valid, array of error messages otherwise
  def self.validate(object, options)
    self.new(object, options).validate
  end

  def self.validate_options(options)
    PureValidator::ArgsValidator.is_hash!(options, :validation_rule)
    PureValidator::ArgsValidator.has_only_allowed_keys!(options, [:min, :max, :equal_to, :not_equal_to], :validation_rule)
  end

  attr_accessor :object, :options, :errors
  def initialize(object, options)
    @object, @options = object, options
    @errors = []
  end

  def validate
    return errors if object.nil?

    handle_min
    handle_max
    handle_equal_to
    handle_not_equal_to

    errors
  end

  def handle_min
    return unless options[:min]
    if object.length < options[:min]
      add_error!('errors.can_not_be_less_than', options[:min])
    end
  end

  def handle_max
    return unless options[:max]
    if object.length > options[:max]
      add_error!('errors.can_not_be_more_than', options[:max])
    end
  end

  def handle_equal_to
    return unless options[:equal_to]
    if object.length != options[:equal_to]
      add_error!('errors.should_be_equal_to', options[:equal_to])
    end
  end

  def handle_not_equal_to
    return unless options[:not_equal_to]
    if object.length == options[:not_equal_to]
      add_error!('errors.should_not_be_equal_to', options[:not_equal_to])
    end
  end

  def add_error!(key, length)
    errors << PureValidator::I18n.t(key, length: length)
  end
end
