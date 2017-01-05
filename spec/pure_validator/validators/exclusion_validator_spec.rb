require 'spec_helper'

describe PureValidator::Validators::ExclusionValidator do
  describe ".validate" do
    it "should return empty errors if value is valid" do
      errors = PureValidator::Validators::ExclusionValidator.validate(:wrong_type, in: [:new, :old, :medium])
      errors.should be_empty
    end

    it "should return errors if value is invalid" do
      errors = PureValidator::Validators::ExclusionValidator.validate(:new, in: [:new, :old, :medium])
      errors.should == ["should not be included in [:new, :old, :medium]"]
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      lambda do
        PureValidator::Validators::ExclusionValidator.validate_options(wrong_option: false, in: [])
      end.should raise_error("validation_rule has unacceptable options [:wrong_option]")
    end
  end
end
