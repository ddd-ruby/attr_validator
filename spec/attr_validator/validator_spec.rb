require 'spec_helper'

describe AttrValidator::Validator do
  describe "#validate" do
    class Contact
      attr_accessor :first_name, :last_name, :position, :age, :type, :email, :color, :status, :stage, :description, :companies, :address
    end

    class Company
      attr_accessor :name
    end

    class Address
      attr_accessor :city, :street
    end

    class CompanyValidator
      include AttrValidator::Validator

      validates :name, presence: true, length: { min: 3, max: 9 }
    end

    class AddressValidator
      include AttrValidator::Validator

      validates :city, presence: true, length: { min: 3, max: 33 }
      validates :street, presence: true, length: { min: 3, max: 33 }
    end

    class ContactValidator
      include AttrValidator::Validator

      validates :first_name, presence: true, length: { min: 4, max: 7 }
      validates :last_name,  length: { equal_to: 5 }
      validates :position,   length: { not_equal_to: 5 }
      validates :age,        numericality: { greater_than: 0, less_than: 150 }
      validates :type,       numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
      validates :email,      email: true
      validates :color,      regexp: /#\w{6}/
      validates :status,     inclusion: { in: [:new, :lead] }
      validates :stage,      exclusion: { in: [:wrong, :bad] }

      validate_associated :companies, validator: CompanyValidator

      validates :address, presence: true
      validate_associated :address, validator: AddressValidator


      validate :check_description

      def check_description(entity, errors)
        if entity.description.nil?
          errors.add(:description, "can't be empty")
        end
      end
    end

    it "should return empty errors if object is valid" do
      contact = Contact.new
      contact.first_name  = "John"
      contact.last_name   = "Smith"
      contact.position    = "Team Lead"
      contact.age         = 35
      contact.type        = 2
      contact.email       = "johh.smith@example.com"
      contact.color       = "#DDD333"
      contact.status      = :lead
      contact.stage       = :good
      contact.description = "good guy"

      company1 = Company.new
      company1.name = 'DroidLabs'
      company2 = Company.new
      company2.name = 'ICL'

      contact.companies = [company1, company2]

      address = Address.new.tap do |a| a.city = "New York" ; a.street = "Wall Street" end
      contact.address = address

      errors = ContactValidator.new.validate(contact)
      errors.should be_empty
    end

    it "should return validation errors if object is invalid" do
      contact = Contact.new
      contact.first_name = nil
      contact.last_name  = "Sm"
      contact.position   = "develp"
      contact.age        = -1
      contact.type       = 7
      contact.email      = "johh.com"
      contact.color      = "DDD333"
      contact.status     = :left
      contact.stage      = :bad

      company1 = Company.new
      company1.name = 'DroidLabs Wrong'
      company2 = Company.new
      company2.name = 'IC'

      contact.companies = [company1, company2]

      errors = ContactValidator.new.validate(contact)
      errors.should == {
        first_name: ["can not be blank"],
        last_name: ["should be equal to 5"],
        age: ["should be greater than 0"],
        type: ["should be less than or equal to 5"],
        email: ["invalid email"],
        color: ["does not match defined format"],
        status: ["should be included in [:new, :lead]"],
        stage: ["should not be included in [:wrong, :bad]"],
        description: ["can't be empty"],
        companies_errors: [
          { name: ["can not be more than 9"] },
          { name: ["can not be less than 3"] },
        ],
        address: ["can not be blank"],
      }
    end
  end

  context "some error cases" do
    context "validate" do
      it "raises with improper :validate definition" do
        expect{
          class ValidateWithoutArgsValidator
            include AttrValidator::Validator
            validate
          end
        }.to raise_error(ArgumentError, "method name or block should be given for validate")
      end
    end

    it "raises with non-existing validators" do
      expect {
        validator_class = Class.new do
          include AttrValidator::Validator
          validates :last_name,  lengths: { equal_to: 5 }
        end
      }.to raise_error(AttrValidator::Errors::MissingValidatorError, "Validator with name 'lengths' doesn't exist")
    end

    it "allows procs as validators" do
      validator_class = Class.new do
        include AttrValidator::Validator

        validate :shtick do |entity, errors|
          errors.set(:shtick, AttrValidator::I18n.t('errors.can_not_be_nil'))
        end
      end

      klass = Class.new do
        attr_accessor :shtick
      end

      expect(validator_class.new.validate(klass.new)).to eq({:shtick=>"can not be nil"})
      expect(validator_class.new.validate({})).to eq({:shtick=>"can not be nil"})
    end
  end
end
