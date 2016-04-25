module Validations
  class SignupFormCompanyName
    include ActiveModel::Model
    include Virtus

    attribute :name, String

    attr_accessor :made_valid

    validates :name, presence: true

    validate do |user|
      ::UserValidator.new(user).validate
    end

    def save
      if valid?
        persist!
        true
      else
        false
      end
    end

    private

    def persist!
      true
    end
  end
end
