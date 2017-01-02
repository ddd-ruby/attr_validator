require "spec_helper"


describe "AttrValidator::ValidationErrors" do
  let(:errors){AttrValidator::ValidationErrors.new}


  context "construction" do
    it "works with :add" do
      errors.add(:name, 'is invalid')
      expect(errors.size).to eq(1)
    end

    it "works with []=" do
      errors[:name] = 'is invalid'
      expect(errors.size).to eq(1)
      expect(errors.count).to eq(1)
    end
  end

  context ":clear" do
    it "clears messages" do
      errors.add(:name, 'is invalid')
      expect(errors.size).to eq(1)
      errors.clear
      expect(errors.size).to eq(0)
    end
  end

  context "include?" do
    it "checks if message already present" do
      errors.add(:name, 'is invalid')
      expect(errors.include?(:name)).to eq(true)
      expect(errors.include?(:names)).not_to eq(true)
    end
  end

  context "delete" do
    it "removes message" do
      errors.add(:name, 'is invalid')
      errors.add(:age, 'is invalid')
      expect(errors.include?(:age)).to eq(true)
      errors.delete(:age)
      expect(errors.include?(:age)).not_to eq(true)
    end
  end


  context "each" do
    it "yields name, error" do
      errors.add(:name, "must be specified")
      errors.each do |attribute, error|
        expect(attribute).to eq(:name)
        expect(error).to eq("must be specified")
      end
    end
  end

  context "keys" do
    it "returns attribute names" do
      errors.add(:name, "must be specified")
      errors.add(:age, "must be specified")
      expect(errors.keys).to eq([:name, :age])
    end
  end


  context "added?" do
    it "Returns +true+ if an error on the attribute with the given message is present" do
      errors.add :name, :blank
      expect(errors.added?(:name, :blank)).to eq(true)
    end
  end

  context "full_messages" do
    it "returns attribute names" do
      errors.add(:name, "must be specified")
      errors.add(:age, "must be specified")
      expect(errors.full_messages).to eq(["Name [\"must be specified\"]", "Age [\"must be specified\"]"])
    end
  end

  context "full_messages_for" do
    it "returns attribute names" do
      errors.add(:name, "must be specified")
      errors.add(:name, "min. 3 chars")
      expect(errors.full_messages_for(:name)).to eq(["Name must be specified", "Name min. 3 chars"])
    end
  end

  context "to_hash" do
    it "Returns a Hash of attributes with their error messages" do
      errors.add(:name, "must be specified")
      errors.add(:name, "min. 3 chars")
      expect(errors.to_hash).to eq({:name => ["must be specified", "min. 3 chars"]})
      expect(errors.to_hash(true)).to eq({:name => ["Name must be specified", "Name min. 3 chars"]})
    end
  end

  context "empty?" do
    it "Returns +true+ if no errors are found" do
      errors.add(:name, "must be specified")
      errors.add(:name, "min. 3 chars")
      expect(errors.empty?).to eq(false)
      errors.clear
      expect(errors.empty?).to eq(true)
    end
  end
end
