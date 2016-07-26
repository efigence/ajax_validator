# Use with form object that responds to `validate` method,
# e.g. use Reform or Virtus with ActiveModel::Validations
#
# Open the console and try:
#
#   validator_params = { form_object: 'validations/signup_form_company_name',
#                        resource_model: 'company',
#                        resource_attr_name: 'name',
#                        resource_attr_value: 'Efigence' }
#
# One can use the engine with any ActiveModel::Model object with ActiveModel::Validations
# included. For performance, even if the model is clobbered with validations, only validations
# on the specified field one will be fired. Examples:
#
#   validator_params = { form_object: '',
#                        resource_model: 'company',
#                        resource_attr_name: 'name',
#                        resource_attr_value: 'efigence' }
#
# Validate (also conditionally) virtual or model attribute set inside some before validation callback:
#
#   validator_params = { form_object: '',
#                        resource_model: 'company',
#                        resource_attr_name: 'vat_number_with_prefix',
#                        resource_attr_value: '',
#                        ignore_resource_attr_value: 'true',
#                        resource_instance_additional_params: {country: 'Poland',
#                                                              vat_number: '0123456789'} }
#
#   validator_params = { form_object: '',
#                        resource_model: 'company',
#                        resource_attr_name: 'vat_number',
#                        resource_attr_value: '',
#                        ignore_resource_attr_value: 'true',
#                        resource_instance_additional_params: {business_owner: true,
#                                                              vat_number: ''} }
#
# validator = AjaxValidator::Validator.new(validator_params)
# tested_company = validator.validate
# tested_company.errors.to_a
#
# - `resource_instance_additional_params` hash is passed as args to given active model instance,
# to handle before validation callbacks' dependencies, however, if form object is used,
# additional params - if specified - must be handled by form object instance itself,
# implementations may vary.
# - set `ignore_resource_attr_value` to 'true' if attribute value is assembled inside before validation
# callback
# - validating virtual attributes, custom validation methods and custom validators are all supported
module AjaxValidator
  class Validator

    def initialize(params = {})
      @form_object = params[:form_object] # optional
      @resource_model = params[:resource_model]
      @resource_attr_name = params[:resource_attr_name]
      @resource_attr_value = params[:resource_attr_value]
      # skip setter if attribute is being assembled inside before validation callback
      @ignore_resource_attr_value = params[:ignore_resource_attr_value].to_s == 'true'
      if params[:resource_instance_additional_params].present?
        @resource_instance_additional_params = params[:resource_instance_additional_params]
      end
      @bypass_whitelist = false
    end

    attr_accessor :form_object, :resource_model, :resource_attr_name, :resource_attr_value, :resource_instance_additional_params, :ignore_resource_attr_value, :bypass_whitelist

    def validate
      form_object_klass, resource_model_klass = safely_constantized_klasses
      if form_object_klass
        validate_form_object(resource_model_klass, form_object_klass)
      else
        validate_resource_model(resource_model_klass)
      end
    end

    private

    def safely_constantized_klasses
      if form_object.present?
        guard_whitelist(form_object)
        form_object_klass = constantize_klass(form_object)
      else
        form_object_klass = nil
      end
      if resource_model.present?
        guard_whitelist(resource_model)
        resource_model_klass = constantize_klass(resource_model)
      else
        resource_model_klass = nil
      end
      guard_whitelist(Object) if form_object_klass.nil? && resource_model_klass.nil?
      [form_object_klass, resource_model_klass]
    end

    def constantize_klass(klass)
      klass.to_s.classify.constantize
    end

    def validate_form_object(resource_model_klass, form_object_klass)
      if resource_instance_additional_params
        resource_instance = resource_model_klass.new(resource_instance_additional_params)
      else
        resource_instance = resource_model_klass.new
      end
      # support composition
      klass_object = form_object_klass.new(resource_model.to_s => resource_instance) rescue nil
      klass_object ||= form_object_klass.new(resource_instance)
      klass_object.validate(resource_attr_name.to_s => resource_attr_value.to_s)
      klass_object
    end

    def validate_resource_model(resource_model_klass)
      klass_object = resource_model_klass.new(resource_instance_additional_params)
      # run before_validation callback for active model (https://github.com/rails/rails/issues/718#issuecomment-1170499)
      klass_object.try(:run_callbacks, :validation) { false }
      if ignore_resource_attr_value
        klass_object.send(:ajax_validator_valid_attribute?, resource_attr_name.to_s, klass_object.try(:send, resource_attr_name))
      else
        klass_object.send(:ajax_validator_valid_attribute?, resource_attr_name.to_s, resource_attr_value.to_s)
      end
      klass_object
    end

    def guard_whitelist(object)
      unless bypass_whitelist
        unless AjaxValidator::Engine.config[:whitelist_klasses].to_a.map{|i| i.to_s.underscore}.include?(object.to_s.underscore)
          raise 'Class was not whitelisted!'
        end
      end
    end
  end
end

