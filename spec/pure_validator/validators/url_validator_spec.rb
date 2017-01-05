require 'spec_helper'

describe PureValidator::Validators::UrlValidator do
  def validate(*args)
    PureValidator::Validators::UrlValidator.validate(*args)
  end

  def passes(v)
    expect(v).to be_empty
  end

  def fails(v, errors)
    expect(v).to eq(errors)
  end

  describe ".validate" do
    it "should return empty errors if email is valid" do
      passes(validate('example-asdf.com', true))
    end

    it "should return errors if value is invalid" do
      fails(validate(':123asdffd.com', true), ["invalid url"])
    end

    context "false as url_flag" do
      it "fails if url is valid" do
        fails(validate('example-asdf.com', false), ["can not be a url"])
      end

      it "passes if url is invalid" do
        passes(validate(':123asdffd.com', false))
      end
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      expect{
        PureValidator::Validators::UrlValidator.validate_options("asdf")
      }.to raise_error("validation_rule should be a Boolean")
    end
  end
end
