class PureValidator::Validators::UrlValidator
  URL_REGEXP = /^(https?:\/\/)?([\w\.-]+)\.([a-z]{2,6}\.?)(\/[\w\.]*)*\/?$/

  # Validates that string is a valid url
  # @param value [String] string to validate
  # @param url [Boolean] should given string be url or not
  # @return [Array] empty array if number is valid, array of error messages otherwise
  def self.validate(value, url_flag)
    return [] if value.nil?

    errors = []
    if url_flag
      errors << PureValidator::I18n.t('errors.invalid_url') unless !!URL_REGEXP.match(value)
    else
      errors << PureValidator::I18n.t('errors.can_not_be_url') if !!URL_REGEXP.match(value)
    end

    errors
  end

  def self.validate_options(url_flag)
    PureValidator::ArgsValidator.is_boolean!(url_flag, :validation_rule)
  end

end
