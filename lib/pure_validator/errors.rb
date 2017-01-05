module PureValidator::Errors
  # Thrown when object has validation errors
  class ValidationError < StandardError
    attr_reader :errors

    def initialize(message, errors)
      @errors = errors
      super(message)
    end

    def message
      "#{@message}\n#{errors}"
    end

    def short_message
      'Validation error'
    end
  end


  # Thrown when validator is not defined
  class MissingValidatorError < StandardError; end
end
