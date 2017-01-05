require 'spec_helper'

describe PureValidator::Validators::NumericalityValidator do
  def validate(*args)
    PureValidator::Validators::NumericalityValidator.validate(*args)
  end

  def passes(v)
    expect(v).to be_empty
  end

  def fails(v, errors)
    expect(v).to eq(errors)
  end

  describe ".validate" do
    it "should return empty errors if number is valid" do
      passes(validate(4, less_than: 5, greater_than: 3))
    end

    it "should return errors if value is less than needed" do
      fails(validate(5, greater_than: 5), ["should be greater than 5"])
    end

    it "should return errors if value is less than or equal to what needed" do
      fails(validate(4, greater_than_or_equal_to: 5), ["should be greater than or equal to 5"])
    end

    it "should return errors if value is greater than needed" do
      fails(validate(5, less_than: 5), ["should be less than 5"])
    end

    it "should return errors if value is greater than or equal to what needed" do
      fails(validate(6, less_than_or_equal_to: 5), ["should be less than or equal to 5"])
    end

    it "should return errors if value is not even" do
      fails(validate(7, even: true), ["should be even number"])
    end

    it "should return errors if value is not odd" do
      fails(validate(6, odd: true), ["should be odd number"])
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      expect{
        PureValidator::Validators::NumericalityValidator.validate_options(less_than: 5, wrong_attr: 3)
      }.to raise_error("validation_rule has unacceptable options [:wrong_attr]")
    end
  end
end
