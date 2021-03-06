require 'spec_helper'

describe PureValidator::Validators::InclusionValidator do
  describe ".validate" do
    it "should return empty errors if value is valid" do
      errors = PureValidator::Validators::InclusionValidator.validate(:old, in: [:new, :old, :medium])
      expect(errors).to be_empty
    end

    it "should return errors if value is invalid" do
      errors = PureValidator::Validators::InclusionValidator.validate(:wrong_type, in: [:new, :old, :medium])
      expect(errors).to eq(["should be included in [:new, :old, :medium]"])
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      expect{
        PureValidator::Validators::InclusionValidator.validate_options(wrong_option: false, in: [])
      }.to raise_error("validation options has unacceptable options [:wrong_option]")
    end
  end
end
