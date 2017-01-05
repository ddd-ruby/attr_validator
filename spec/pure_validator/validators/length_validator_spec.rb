require 'spec_helper'

describe PureValidator::Validators::LengthValidator do
  describe ".validate" do
    it "should return empty errors if text has valid length" do
      errors = PureValidator::Validators::LengthValidator.validate('home', max: 5, min: 3)
      expect(errors).to be_empty
    end

    it "should return errors if value has invalid max length" do
      errors = PureValidator::Validators::LengthValidator.validate('long title', max: 5)
      expect(errors).to eq(["can not be more than 5"])
    end

    it "should return errors if value has invalid min length" do
      errors = PureValidator::Validators::LengthValidator.validate('ya', min: 3)
      expect(errors).to eq(["can not be less than 3"])
    end

    it "should return errors if value has invalid equal_to length" do
      errors = PureValidator::Validators::LengthValidator.validate('ya', equal_to: 3)
      expect(errors).to eq(["should be equal to 3"])
    end

    it "should return errors if value has invalid not_equal_to length" do
      errors = PureValidator::Validators::LengthValidator.validate('yad', not_equal_to: 3)
      expect(errors).to eq(["should not be equal to 3"])
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      expect {
        PureValidator::Validators::LengthValidator.validate_options(max: 5, wrong_attr: 3)
      }.to raise_error("validation_rule has unacceptable options [:wrong_attr]")
    end
  end
end
