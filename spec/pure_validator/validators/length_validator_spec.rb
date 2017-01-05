require 'spec_helper'

describe PureValidator::Validators::LengthValidator do
  describe ".validate" do
    it "should return empty errors if text has valid length" do
      errors = PureValidator::Validators::LengthValidator.validate('home', max: 5, min: 3)
      errors.should be_empty
    end

    it "should return errors if value has invalid max length" do
      errors = PureValidator::Validators::LengthValidator.validate('long title', max: 5)
      errors.should == ["can not be more than 5"]
    end

    it "should return errors if value has invalid min length" do
      errors = PureValidator::Validators::LengthValidator.validate('ya', min: 3)
      errors.should == ["can not be less than 3"]
    end

    it "should return errors if value has invalid equal_to length" do
      errors = PureValidator::Validators::LengthValidator.validate('ya', equal_to: 3)
      errors.should == ["should be equal to 3"]
    end

    it "should return errors if value has invalid not_equal_to length" do
      errors = PureValidator::Validators::LengthValidator.validate('yad', not_equal_to: 3)
      errors.should == ["should not be equal to 3"]
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      lambda do
        PureValidator::Validators::LengthValidator.validate_options(max: 5, wrong_attr: 3)
      end.should raise_error("validation_rule has unacceptable options [:wrong_attr]")
    end
  end
end
