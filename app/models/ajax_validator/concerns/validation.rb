module AjaxValidator
  module Concerns
    module Validation
      extend ActiveSupport::Concern
      included do
        private
        def ajax_validator_valid_attribute?(resource_attr_name, resource_attr_value, model_instance = self)
          model_instance.class.validators_on(resource_attr_name.to_sym).each do |validator|
            if validator.options[:if]
              next unless !!model_instance.send(validator.options[:if])
            end
            if validator.options[:unless]
              next if !!model_instance.send(validator.options[:unless])
            end
            validator.validate_each(model_instance, resource_attr_name.to_sym, resource_attr_value)
          end
        end
      end
    end
  end
end
