require 'spec_helper'

describe PureValidator::Validators::PresenceValidator do
  def validate(*args)
    PureValidator::Validators::PresenceValidator.validate(*args)
  end

  def passes(v)
    expect(v).to be_empty
  end

  def fails(v, errors)
    expect(v).to eq(errors)
  end

  describe ".validate" do
    it "should return empty errors if text is not blank" do
      passes(validate('home', true))
    end

    it "should return errors if text is not specified" do
      fails(validate(" ", true), ["can not be blank"])
    end

    it "should return errors if text is not specified" do
      fails(validate("1", false), ["should be blank"])
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      expect {
        PureValidator::Validators::PresenceValidator.validate_options("asdf")
      }.to raise_error("validation_rule should be a Boolean")
    end
  end

end
