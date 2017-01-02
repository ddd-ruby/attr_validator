require "spec_helper"


describe "AttrValidator::Errors::ValidationError" do
  it "works" do
    error = AttrValidator::Errors::ValidationError.new("wrong", [:a, :b])
    expect(error.message).to eq("\n[:a, :b]")
    expect(error.short_message).to eq("Validation error")
  end
end
