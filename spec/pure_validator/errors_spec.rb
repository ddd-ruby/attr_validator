require "spec_helper"


describe "PureValidator::Errors::ValidationError" do
  it "works" do
    error = PureValidator::Errors::ValidationError.new("wrong", [:a, :b])
    expect(error.message).to eq("\n[:a, :b]")
    expect(error.short_message).to eq("Validation error")
  end
end
