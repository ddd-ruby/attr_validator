class AttrValidator::Validators::InclusionValidator

  # Validates that given value inscluded in the specified list
  # @param value [Object] object to validate
  # @parm options [Hash] validation options, e.g. { in: [:small, :medium, :large], message: "not included in the list of allowed items" }
  #                      where :in - list of allowed values,
  #                      message - is a message to return if value is not included in the list
  # @return Boolean true if object is included in the list, false otherwise
  def self.validate(value, options)
    return [] if value.nil?

    errors = []
    unless options[:in].include?(value)
      errors << (options[:message] || AttrValidator::I18n.t('errors.should_be_included_in_list', list: options[:in]))
    end
    errors
  end

  # Validates that options specified in
  # :inclusion are valid
  def self.validate_options(options)
    AttrValidator::ArgsValidator.is_hash!(options, 'validation options')
    AttrValidator::ArgsValidator.has_key!(options, :in)
    AttrValidator::ArgsValidator.has_only_allowed_keys!(options, [:in, :message], 'validation options')
  end

end
