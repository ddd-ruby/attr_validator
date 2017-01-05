class PureValidator::Validators::RegexpValidator

  # Validates that given value match regexp if regexp validation exists
  # @param value String value to match with regexp
  # @param regexp [Regexp] regexp to match
  # @return [Array] empty array if number is valid, array of error messages otherwise
  def self.validate(value, regexp)
    return [] if value.nil?

    errors = []
    unless !!regexp.match(value)
      errors << PureValidator::I18n.t('errors.does_not_match')
    end
    errors
  end

  def self.validate_options(regexp)
    PureValidator::ArgsValidator.is_string_or_regexp!(regexp, :validation_rule)
  end

end
