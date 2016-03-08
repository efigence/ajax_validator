module AjaxValidator
  class Engine < ::Rails::Engine
    isolate_namespace AjaxValidator

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end

    config.to_prepare do
      Rails.application.config.try(:ajax_validator_engine).try(:[], :whitelist_klasses).to_a.each do |whitelist_klass|
        begin
          klass = whitelist_klass.to_s.classify.constantize
        rescue
          raise "Can\'t constantize from \'#{whitelist_klass}\'. Check if class exists."
        end
        klass.include AjaxValidator::Concerns::Validation
      end
    end

    def self.setup(&block)
      @@config ||= AjaxValidator::Engine::Configuration.new
      yield @@config if block
      return @@config
    end

    def self.config
      puts 'WARNING: ajax_validator_engine not configured' unless Rails.application.config.try(:ajax_validator_engine)
      Rails.application.config.ajax_validator_engine
    end

    # will not reload in development
    #initializer :prepare_models_for_ajax_validator do |app|
    #end

    #config.to_prepare do
    #  Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
    #    require_dependency(c)
    #  end
    #end
  end
end
