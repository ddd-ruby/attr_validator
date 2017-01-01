require "spec_helper"

describe AttrValidator::ArgsValidator do
  context "::is_symbol!" do
    it "works with symbol" do
      AttrValidator::ArgsValidator.is_symbol!(:symbol, "some.name")
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.is_symbol!("symbol", "some.name")
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "some.name should be a Symbol")
    end
  end

  context "::is_boolean!" do
    it "works with boolean" do
      AttrValidator::ArgsValidator.is_boolean!(true, "some.name")
      AttrValidator::ArgsValidator.is_boolean!(false, "some.name")
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.is_boolean!("true", "some.name")
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "some.name should be a Boolean")
    end
  end

  context "::is_integer!" do
    it "works with integer" do
      AttrValidator::ArgsValidator.is_integer!(1, "some.name")
      AttrValidator::ArgsValidator.is_integer!(0, "some.name")
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.is_integer!("true", "some.name")
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "some.name should be an Integer")
    end
  end

  context "::is_array!" do
    it "works with array" do
      AttrValidator::ArgsValidator.is_array!([], "some.name")
      AttrValidator::ArgsValidator.is_array!([1], "some.name")
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.is_array!("true", "some.name")
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "some.name should be an Array")
    end
  end

  context "::is_hash!" do
    it "works with hash" do
      AttrValidator::ArgsValidator.is_hash!({}, "some.name")
      AttrValidator::ArgsValidator.is_hash!({a:1}, "some.name")
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.is_hash!("true", "some.name")
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "some.name should be a Hash")
    end
  end

  context "::is_integer_or_float!" do
    it "works with integer or float" do
      AttrValidator::ArgsValidator.is_integer_or_float!(1, "some.name")
      AttrValidator::ArgsValidator.is_integer_or_float!(1.3, "some.name")
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.is_integer_or_float!("true", "some.name")
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "some.name should be an Integer or Float")
    end
  end

  context "::is_string_or_regexp!" do
    it "works with string or regexp" do
      AttrValidator::ArgsValidator.is_string_or_regexp!("string", "some.name")
      AttrValidator::ArgsValidator.is_string_or_regexp!(/regex/, "some.name")
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.is_string_or_regexp!(1, "some.name")
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "some.name should be a String or Regexp")
    end
  end

  context "::is_class_or_symbol!" do
    it "works with class or symbol" do
      AttrValidator::ArgsValidator.is_class_or_symbol!(:symbol, "some.name")
      AttrValidator::ArgsValidator.is_class_or_symbol!(String, "some.name")
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.is_class_or_symbol!(1, "some.name")
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "some.name should be a Symbol or Class")
    end
  end

  context "::is_symbol_or_block!" do
    it "works with symbol or block" do
      AttrValidator::ArgsValidator.is_symbol_or_block!(:symbol, "some.name")
      AttrValidator::ArgsValidator.is_symbol_or_block!(-> {puts 1}, "some.name")
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.is_symbol_or_block!(1, "some.name")
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "some.name should be a Symbol or Proc")
    end
  end

  context "::has_key!" do
    it "works when hash has a key" do
      AttrValidator::ArgsValidator.has_key!({a: 1}, :a)
      AttrValidator::ArgsValidator.has_key!({b: 1}, :b)
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.has_key!({a: 1}, :b)
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "{:a=>1} should have 'b' key")
    end
  end

  context "::not_nil!" do
    it "works when hash has a key" do
      AttrValidator::ArgsValidator.not_nil!(1, "some.name")
      AttrValidator::ArgsValidator.not_nil!(true, "some.name")
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.not_nil!(nil, "some.name")
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "some.name can't be nil")
    end
  end

  context "::has_only_allowed_keys!" do
    it "works when hash has a key" do
      AttrValidator::ArgsValidator.has_only_allowed_keys!({a: 1, b: 2}, [:a, :b, :c], "some.name")
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.has_only_allowed_keys!({a: 1, b: 2}, [:a, :c], "some.name")
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "some.name has unacceptable options [:b]")
    end
  end

  context "::block_given!" do
    it "works when hash has a key" do
      AttrValidator::ArgsValidator.block_given!(true)
    end

    it "raises else" do
      expect{
        AttrValidator::ArgsValidator.block_given!(false)
      }.to raise_error(AttrValidator::ArgsValidator::ArgError, "Block should be given")
    end
  end
end
