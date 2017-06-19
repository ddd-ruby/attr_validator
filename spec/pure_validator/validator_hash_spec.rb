require 'spec_helper'

describe PureValidator::Validator do
  describe "#validate" do
    class ContactH
      attr_accessor :first_name, :last_name, :position, :age, :type,
        :email, :color, :status, :stage, :description,
        :companies, :address

      def to_h
        {
          first_name: first_name,
          last_name: last_name,
          position: position,
          age: age,
          type: type,
          email: email,
          color: color,
          status: status,
          stage: stage,
          description: description,
          companies: (companies||[]).map(&:to_h),
          address: (address && address.to_h),
        }
      end
    end

    class CompanyH
      attr_accessor :name

      def to_h
        {name: name}
      end
    end

    class AddressH
      attr_accessor :city, :street
      def to_h
        {
          city: city,
          street: street,
        }
      end
    end

    class CompanyValidatorH
      include PureValidator::Validator

      validates :name, presence: true, length: { min: 3, max: 9 }
    end

    class AddressValidatorH
      include PureValidator::Validator

      validates :city, presence: true, length: { min: 3, max: 33 }
      validates :street, presence: true, length: { min: 3, max: 33 }
    end

    class ContactValidatorH
      include PureValidator::Validator

      validates :first_name, presence: true, length: { min: 4, max: 7 }
      validates :last_name,  length: { equal_to: 5 }
      validates :position,   length: { not_equal_to: 5 }
      validates :age,        numericality: { greater_than: 0, less_than: 150 }
      validates :type,       numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
      validates :email,      email: true
      validates :color,      regexp: /#\w{6}/
      validates :status,     inclusion: { in: [:new, :lead] }
      validates :stage,      exclusion: { in: [:wrong, :bad] }

      validate_associated :companies, validator: CompanyValidatorH

      validates :address, presence: true
      validate_associated :address, validator: AddressValidatorH


      validate :check_description

      def check_description(entity, errors)
        if entity[:description].nil?
          errors.add(:description, "can't be empty")
        end
      end
    end

    it "should return empty errors if object is valid" do
      contact = ContactH.new
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

      company1 = CompanyH.new
      company1.name = 'DroidLabs'
      company2 = CompanyH.new
      company2.name = 'ICL'

      contact.companies = [company1, company2]

      address = AddressH.new.tap do |a| a.city = "New York" ; a.street = "Wall Street" end
      contact.address = address

      errors = ContactValidatorH.new.validate(contact.to_h)
      expect(errors).to be_empty
    end

    it "should return validation errors if object is invalid" do
      contact = ContactH.new
      contact.first_name = nil
      contact.last_name  = "Sm"
      contact.position   = "develp"
      contact.age        = -1
      contact.type       = 7
      contact.email      = "johh.com"
      contact.color      = "DDD333"
      contact.status     = :left
      contact.stage      = :bad

      company1 = CompanyH.new
      company1.name = 'DroidLabs Wrong'
      company2 = CompanyH.new
      company2.name = 'IC'

      contact.companies = [company1, company2]
      errors = ContactValidatorH.new.validate(contact.to_h)
      expect(errors).to eq(
        {
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
      )
    end
  end
end
