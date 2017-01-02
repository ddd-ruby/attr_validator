require 'spec_helper'

describe AttrValidator::Validators::UrlValidator do
  describe ".validate" do
    it "should return empty errors if email is valid" do
      errors = AttrValidator::Validators::UrlValidator.validate('example-asdf.com', true)
      errors.should be_empty
    end

    it "should return errors if value is invalid" do
      errors = AttrValidator::Validators::UrlValidator.validate(':123asdffd.com', true)
      errors.should == ["invalid url"]
    end

    context "false as url_flag" do
      it "fails if url is valid" do
        errors = AttrValidator::Validators::UrlValidator.validate('example-asdf.com', false)
        expect(errors).to eq(["can not be a url"])
      end

      it "passes if url is invalid" do
        errors = AttrValidator::Validators::UrlValidator.validate(':123asdffd.com', false)
        expect(errors).to eq([])
      end
    end
  end

  describe ".validate_options" do
    it "should raise error if validation attributes are invalid" do
      lambda do
        AttrValidator::Validators::UrlValidator.validate_options("asdf")
      end.should raise_error("validation_rule should be a Boolean")
    end
  end
end
