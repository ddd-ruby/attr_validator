require 'i18n'
require 'attr_validator/core_extensions/class_attribute'
require 'attr_validator/core_extensions/humanize'
require 'attr_validator/concern'
require 'attr_validator/version'
require 'attr_validator/errors'
require 'attr_validator/args_validator'
require 'attr_validator/validator'
require 'attr_validator/i18n'
require 'attr_validator/validators'
require 'attr_validator/validation_errors'

module AttrValidator
  @@validators = {}

  # Returns list of defined validators
  def self.validators
    @@validators
  end

  # Adds new validator to AttrValidator
  # @param validator_name [Symbol] validator name
  # @param validator      [.validate, .validation_options] validator
  def self.add_validator(validator_name, validator)
    @@validators[validator_name] = validator
  end
end

AttrValidator.add_validator(:email,        AttrValidator::Validators::EmailValidator)
AttrValidator.add_validator(:exclusion,    AttrValidator::Validators::ExclusionValidator)
AttrValidator.add_validator(:inclusion,    AttrValidator::Validators::InclusionValidator)
AttrValidator.add_validator(:length,       AttrValidator::Validators::LengthValidator)
AttrValidator.add_validator(:numericality, AttrValidator::Validators::NumericalityValidator)
AttrValidator.add_validator(:presence,     AttrValidator::Validators::PresenceValidator)
AttrValidator.add_validator(:not_blank,    AttrValidator::Validators::PresenceValidator)
AttrValidator.add_validator(:not_nil,      AttrValidator::Validators::NotNilValidator)
AttrValidator.add_validator(:regexp,       AttrValidator::Validators::RegexpValidator)
AttrValidator.add_validator(:url,          AttrValidator::Validators::UrlValidator)

# I18n settings
I18n.load_path += Dir[File.dirname(__FILE__) +'/attr_validator/locales/*.yml']
I18n.default_locale = :en
I18n.reload!
