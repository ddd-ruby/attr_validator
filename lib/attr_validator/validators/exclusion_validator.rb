class PureValidator::Validators::ExclusionValidator

  # Validates that value isn't in the specified list validation.in
  # @param value Object object to validate exclusion
  # @return Boolean true if object is excluded, false otherwise
  def self.validate(value, options)
    return [] if value.nil?

    errors = []
    if options[:in].include?(value)
      errors << (options[:message] || PureValidator::I18n.t('errors.should_not_be_included_in_list', list: options[:in]))
    end
    errors
  end

  def self.validate_options(options)
    PureValidator::ArgsValidator.is_hash!(options, :validation_rule)
    PureValidator::ArgsValidator.has_key!(options, :in)
    PureValidator::ArgsValidator.has_only_allowed_keys!(options, [:in, :message], :validation_rule)
  end

end
