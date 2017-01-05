require 'spec_helper'

describe PureValidator::Validators::RegexpValidator do
  def validate(*args)
    PureValidator::Validators::RegexpValidator.validate(*args)
  end

  def passes(v)
    expect(v).to be_empty
  end

  def fails(v, errors)
    expect(v).to eq(errors)
  end

  describe ".validate" do
    it "should return empty errors if value is valid" do
      passes(validate('#aaa', /#\w{3,6}/))
    end

    it "should return errors if value is invalid" do
      fails(validate('asdf', /#\w{3,6}/), ["does not match defined format"])
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      expect {
        PureValidator::Validators::RegexpValidator.validate_options({})
      }.to raise_error("validation_rule should be a String or Regexp")
    end
  end
end
