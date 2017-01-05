class PureValidator::Validators::PresenceValidator

  # Validates that given object not nil and not empty
  # if string is given strips it before validating
  # @param value   [Object] object to validate
  # @param presence [Boolean] check presence or not
  # @return [Array] empty array if number is valid, array of error messages otherwise
  def self.validate(value, presence)
    errors = []
    if presence
      if value.nil? || (value.is_a?(String) && value.strip.length == 0)
        errors << PureValidator::I18n.t('errors.can_not_be_blank')
      end
    else
      if value
        errors << PureValidator::I18n.t('errors.should_be_blank')
      end
    end
    errors
  end

  def self.validate_options(presence_flag)
    PureValidator::ArgsValidator.is_boolean!(presence_flag, :validation_rule)
  end

end
