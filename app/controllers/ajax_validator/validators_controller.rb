require_dependency 'ajax_validator/application_controller'

module AjaxValidator
  class ValidatorsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create]

    # POST /validators
    #
    # {
    #     'validator': {
    #         'form_object': 'validations/signup_form_company_name',
    #         'resource_model': 'company'
    #         'resource_attr_name': 'name',
    #         'resource_attr_value': 'Efigence'
    #     }
    # }
    #
    # or:
    #
    # {
    #     'validator': {
    #         'form_object': '',
    #         'resource_model': 'company'
    #         'resource_attr_name': 'name',
    #         'resource_attr_value': 'Efigence'
    #     }
    # }
    #
    # Response (jsonapi.org format)
    #
    # on success:
    #
    # {
    #   'errors': []
    # }
    #
    # on failure:
    #
    # {
    #   'errors': [
    #     {
    #       'name': [
    #         'has already been taken'
    #       ]
    #     }
    #   ]
    # }
    def create
      validated = Validator.new(validator_params).validate
      response = { 'errors' => validated.errors.messages.stringify_keys.map{|i| {i[0] => i[1]}} }
      render json: response.to_json
    end

    private

    # Only allow a trusted parameter 'white list' through.
    def validator_params
      wildcard = params.try(:[], :validator).try(:[], :resource_instance_additional_params).try(:keys)
      params.require(:validator).
      permit(:form_object,
             :resource_model,
             :resource_attr_name,
             :resource_attr_value,
             :ignore_resource_attr_value,
             :resource_instance_additional_params => wildcard)
    end
  end
end
