require 'spec_helper'

describe PureValidator::Validators::NotNilValidator do
  def validate(*args)
    PureValidator::Validators::NotNilValidator.validate(*args)
  end

  def passes(v)
    expect(v).to be_empty
  end

  def fails(v, errors)
    expect(v).to eq(errors)
  end

  describe ".validate" do
    it "should return empty errors if object is not nil" do
      passes(validate('home', true))
    end

    it "should return errors if object is nil" do
      fails(validate(nil, true), ["can not be nil"])
    end

    context "with positive presence flag" do
      it "passes for nil" do
        passes(validate(nil, false))
      end

      it "fails for non-nil" do
        fails(validate(1, false), ["should be nil"])
      end
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      expect{
        PureValidator::Validators::NotNilValidator.validate_options("asdf")
      }.to raise_error("validation_rule should be a Boolean")
    end
  end

end
