class PureValidator::I18n

  # Translates message to specific language
  def self.t(message, options = {})
    I18n.t("attr_validator.#{message}", options)
  end
end
