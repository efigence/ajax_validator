require 'rails_helper'

# https://www.amberbit.com/blog/2015/10/15/rails-mountable-engines/
# http://stackoverflow.com/questions/33754450/rspec-with-capybara-sometimes-not-pass-tests
# RSpec.feature 'Engine management', type: :feature do
#   scenario 'User makes a request', js: true do
#     # visit '/ajax_validator/validators'
#     # fill_in 'Name', with: 'Bad boy'
#     # click_button "Create Widget"
#     # expect(page).to have_text('Name is evil', wait: 5.0)
#   end
# end

RSpec.feature 'Test engine', type: :request do
  before(:all) do
    class ErrorMessages
      def messages
        {}
      end
    end

    class Company
      def self.validators_on(*)
        []
      end

      def errors
        ErrorMessages.new
      end

      private
      def ajax_validator_valid_attribute?(resource_attr_name, resource_attr_value, model_instance = self)
      end
    end

    class Validator
      def validate
        true
      end
    end
  end

  scenario 'User makes a request' do
    AjaxValidator::Engine.setup do |config|
      config.ajax_validator_engine = {
        # if form object is used, both classes must be put here
        whitelist_klasses: ['company'] # , 'validations/signup_form_company_name']
      }
    end


    json = { validator: { form_object: '',
                          resource_model: 'company',
                          resource_attr_name: 'name',
                          resource_attr_value: 'efigence',
                          resource_instance_additional_params: {} } }.to_json

    # https://www.varvet.com/blog/capybara-and-testing-apis/
    post '/ajax_validator/validators', json, 'CONTENT_TYPE' => 'application/json'
    resp = { errors: [] }.to_json
    expect(@response.body).to(
      match(
        Regexp.new(Regexp.escape("#{resp}"))
      )
    )
  end
end
