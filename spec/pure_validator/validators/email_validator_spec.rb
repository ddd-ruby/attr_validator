require 'spec_helper'

describe PureValidator::Validators::EmailValidator do
  describe ".validate" do
    it "should return empty errors if email is valid" do
      errors = PureValidator::Validators::EmailValidator.validate('test@example.com', true)
      expect(errors).to be_empty
    end

    it "should return errors if value is invalid" do
      errors = PureValidator::Validators::EmailValidator.validate('test@asdffd', true)
      expect(errors).to eq(["invalid email"])
    end

    context "false as email_flag" do
      it "fails if email is valid" do
        errors = PureValidator::Validators::EmailValidator.validate('test@example.com', false)
        expect(errors).to eq(["can't be email"])
      end

      it "passes if email is invalid" do
        errors = PureValidator::Validators::EmailValidator.validate('test@asdffd', false)
        expect(errors).to eq([])
      end
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      expect{
        PureValidator::Validators::EmailValidator.validate_options("asdf")
      }.to raise_error("validation_rule should be a Boolean")
    end
  end
end
