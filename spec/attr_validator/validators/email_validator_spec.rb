require 'spec_helper'

describe AttrValidator::Validators::EmailValidator do
  describe ".validate" do
    it "should return empty errors if email is valid" do
      errors = AttrValidator::Validators::EmailValidator.validate('test@example.com', true)
      errors.should be_empty
    end

    it "should return errors if value is invalid" do
      errors = AttrValidator::Validators::EmailValidator.validate('test@asdffd', true)
      errors.should == ["invalid email"]
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      lambda do
        AttrValidator::Validators::EmailValidator.validate_options("asdf")
      end.should raise_error("validation_rule should be a Boolean")
    end
  end
end
