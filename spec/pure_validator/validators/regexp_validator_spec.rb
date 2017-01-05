require 'spec_helper'

describe PureValidator::Validators::RegexpValidator do
  describe ".validate" do
    it "should return empty errors if value is valid" do
      errors = PureValidator::Validators::RegexpValidator.validate('#aaa', /#\w{3,6}/)
      errors.should be_empty
    end

    it "should return errors if value is invalid" do
      errors = PureValidator::Validators::RegexpValidator.validate('asdf', /#\w{3,6}/)
      errors.should == ["does not match defined format"]
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      lambda do
        PureValidator::Validators::RegexpValidator.validate_options({})
      end.should raise_error("validation_rule should be a String or Regexp")
    end
  end
end
