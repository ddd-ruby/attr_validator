require 'spec_helper'

describe PureValidator::Validators::ExclusionValidator do
  describe ".validate" do
    it "should return empty errors if value is valid" do
      errors = PureValidator::Validators::ExclusionValidator.validate(:wrong_type, in: [:new, :old, :medium])
      expect(errors).to be_empty
    end

    it "should return errors if value is invalid" do
      errors = PureValidator::Validators::ExclusionValidator.validate(:new, in: [:new, :old, :medium])
      expect(errors).to eq(["should not be included in [:new, :old, :medium]"])
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      expect{
        PureValidator::Validators::ExclusionValidator.validate_options(wrong_option: false, in: [])
      }.to raise_error("validation_rule has unacceptable options [:wrong_option]")
    end
  end
end
