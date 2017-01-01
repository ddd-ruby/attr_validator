require 'spec_helper'

describe AttrValidator::Validators::PresenceValidator do
  describe ".validate" do
    it "should return empty errors if text is not blank" do
      errors = AttrValidator::Validators::PresenceValidator.validate('home', true)
      errors.should be_empty
    end

    it "should return errors if text is not specified" do
      errors = AttrValidator::Validators::PresenceValidator.validate(" ", true)
      errors.should == ["can not be blank"]
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      lambda do
        AttrValidator::Validators::PresenceValidator.validate_options("asdf")
      end.should raise_error("validation_rule should be a Boolean")
    end
  end

end
