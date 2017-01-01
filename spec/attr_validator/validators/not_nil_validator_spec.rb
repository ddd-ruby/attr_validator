require 'spec_helper'

describe AttrValidator::Validators::NotNilValidator do
  describe ".validate" do
    it "should return empty errors if object is not nil" do
      errors = AttrValidator::Validators::NotNilValidator.validate('home', true)
      errors.should be_empty
    end

    it "should return errors if object is nil" do
      errors = AttrValidator::Validators::NotNilValidator.validate(nil, true)
      errors.should == ["can not be nil"]
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      lambda do
        AttrValidator::Validators::NotNilValidator.validate_options("asdf")
      end.should raise_error("validation_rule should be a Boolean")
    end
  end

end
