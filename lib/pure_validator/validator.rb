module PureValidator::Validator
  extend PureValidator::Concern

  included do
    class_attribute :validations, :associated_validations, :custom_validations
  end

  module ClassMethods
    def validates(*args)
      options = args.pop
      PureValidator::ArgsValidator.is_hash!(options, "last argument")

      self.validations ||= {}
      args.each do |attr_name|
        add_validations(attr_name, options)
      end
    end

    def validate_associated(association_name, options)
      PureValidator::ArgsValidator.not_nil!(options[:validator], :validator)
      PureValidator::ArgsValidator.is_class_or_symbol!(options[:validator], :validator)
      PureValidator::ArgsValidator.is_symbol_or_block!(options[:if], :if) if options[:if]
      PureValidator::ArgsValidator.is_symbol_or_block!(options[:unless], :unless) if options[:unless]

      self.associated_validations ||= {}
      self.associated_validations[association_name] = options
    end

    def validate(method_name = nil, &block)
      self.custom_validations ||= []
      if block_given?
        self.custom_validations << block
      elsif method_name
        PureValidator::ArgsValidator.is_symbol!(method_name, "validate method name")
        self.custom_validations << method_name
      else
        raise ArgumentError, "method name or block should be given for validate"
      end
    end

    private

    def add_validations(attr_name, options)
      self.validations[attr_name] ||= {}
      options.each do |validator_name, validation_options|
        validator = PureValidator.validators[validator_name]
        unless validator
          raise PureValidator::Errors::MissingValidatorError, "Validator with name '#{validator_name}' doesn't exist"
        end
        validator.validate_options(validation_options)
        self.validations[attr_name][validator] = validation_options
      end
    end
  end

  def validate(entity)
    errors = PureValidator::ValidationErrors.new
    self.validations ||= {}
    self.custom_validations ||= []
    self.associated_validations ||= {}

    self.validations.each do |attr_name, validators|
      error_messages = validate_attr(attr_name, entity, validators)
      errors.add_all(attr_name, error_messages) unless error_messages.empty?
    end
    self.associated_validations.each do |association_name, options|
      next if skip_validation?(options)
      validator = options[:validator].is_a?(Class) ? options[:validator].new : self.send(options[:validator])
      children = get_attribute_value(entity, association_name)
      if children.is_a?(Array)
        validate_children(association_name, validator, children, errors)
      elsif children
        validate_child(association_name, validator, children, errors)
      end
    end
    self.custom_validations.each do |custom_validation|
      if custom_validation.is_a?(Symbol)
        self.send(custom_validation, entity, errors)
      else # it's Proc
        custom_validation.call(entity, errors)
      end
    end
    errors.to_hash
  end

  def validate!(entity)
    errors = validate(entity)
    unless errors.empty?
      raise PureValidator::Errors::ValidationError.new("Validation Error", errors)
    end
  end

  private

  def validate_attr(attr_name, entity, validators)
    attr_value = get_attribute_value(entity, attr_name)
    error_messages = []
    validators.each do |validator, validation_rule|
      error_messages = validator.validate(attr_value, validation_rule)
      break unless error_messages.empty?
    end
    error_messages
  end

  def get_attribute_value(entity, attr_name)
    return entity[attr_name] if entity.is_a?(Hash)
    return entity.send(attr_name)
  end

  def skip_validation?(options)
    return unless options[:if] || options[:unless]
    return handle_if_skip_validation(options)     if options[:if]
    return handle_unless_skip_validation(options) if options[:unless]
  end

  def handle_if_skip_validation(options)
    if options[:if].is_a?(Symbol)
      return ! self.send(options[:if])
    elsif options[:if].is_a?(Proc)
      return ! self.instance_exec(&options[:if])
    end
  end

  def handle_unless_skip_validation(options)
    if options[:unless].is_a?(Symbol)
      return self.send(options[:unless])
    elsif options[:unless].is_a?(Proc)
      return self.instance_exec(&options[:unless])
    end
  end

  def validate_children(association_name, validator, children, errors)
    if validator.respond_to?(:validate_all)
      children_errors = validator.validate_all(children)
    elsif validator.respond_to?(:validate)
      children_errors = children.inject([]) do |errors, child|
        errors << validator.validate(child).to_hash
      end
    else
      raise NotImplementedError, "Validator should respond at least to :validate or :validate_all"
    end
    unless children_errors.all?(&:empty?)
      errors.messages["#{association_name}_errors".to_sym] ||= []
      errors.messages["#{association_name}_errors".to_sym] += children_errors
    end
  end

  def validate_child(association_name, validator, child, errors)
    child_errors = validator.validate(child).to_hash
    unless child_errors.empty?
      errors.messages["#{association_name}_errors".to_sym] = child_errors
    end
  end

end
