require 'spec_helper'

describe AttrValidator::Validators::InclusionValidator do
  describe ".validate" do
    it "should return empty errors if value is valid" do
      errors = AttrValidator::Validators::InclusionValidator.validate(:old, in: [:new, :old, :medium])
      errors.should be_empty
    end

    it "should return errors if value is invalid" do
      errors = AttrValidator::Validators::InclusionValidator.validate(:wrong_type, in: [:new, :old, :medium])
      errors.should == ["should be included in [:new, :old, :medium]"]
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      lambda do
        AttrValidator::Validators::InclusionValidator.validate_options(wrong_option: false)
      end.should raise_error("validation options has unacceptable options [:wrong_option]")
    end
  end
end
