require 'spec_helper'

describe AttrValidator::Validators::NumericalityValidator do
  describe ".validate" do
    it "should return empty errors if number is valid" do
      errors = AttrValidator::Validators::NumericalityValidator.validate(4, less_than: 5, greater_than: 3)
      errors.should be_empty
    end

    it "should return errors if value is less than needed" do
      errors = AttrValidator::Validators::NumericalityValidator.validate(5, greater_than: 5)
      errors.should == ["should be greater than 5"]
    end

    it "should return errors if value is less than or equal to what needed" do
      errors = AttrValidator::Validators::NumericalityValidator.validate(4, greater_than_or_equal_to: 5)
      errors.should == ["should be greater than or equal to 5"]
    end

    it "should return errors if value is greater than needed" do
      errors = AttrValidator::Validators::NumericalityValidator.validate(5, less_than: 5)
      errors.should == ["should be less than 5"]
    end

    it "should return errors if value is greater than or equal to what needed" do
      errors = AttrValidator::Validators::NumericalityValidator.validate(6, less_than_or_equal_to: 5)
      errors.should == ["should be less than or equal to 5"]
    end

    it "should return errors if value is not even" do
      errors = AttrValidator::Validators::NumericalityValidator.validate(7, even: true)
      errors.should == ["should be even number"]
    end

    it "should return errors if value is not odd" do
      errors = AttrValidator::Validators::NumericalityValidator.validate(6, odd: true)
      errors.should == ["should be odd number"]
    end

  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      lambda do
        AttrValidator::Validators::NumericalityValidator.validate_options(less_than: 5, wrong_attr: 3)
      end.should raise_error("validation_rule has unacceptable options [:wrong_attr]")
    end
  end
end
