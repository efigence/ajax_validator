# Ajax Validator

> Ajax Live Form Validation Rails Engine

[![Gem Version](https://badge.fury.io/rb/ajax_validator.svg)](https://badge.fury.io/rb/ajax_validator)
[![Build Status](https://travis-ci.org/efigence/ajax_validator.svg?branch=master)](http://travis-ci.org/efigence/ajax_validator)

## Demo

![](https://cloud.githubusercontent.com/assets/34706/13599661/79374eba-e524-11e5-8e1b-e6f77891958d.gif)

## How to install

1. Add to `Gemfile`

        gem 'ajax_validator'
2. Bundle

        bundle install
3. Create file `config/initializers/ajax_validator.rb` and specify validatable models

        AjaxValidator::Engine.setup do |config|
          config.ajax_validator_engine = {
            # if form object is used, both classes must be put here
            whitelist_klasses: ['some_klass', 'some_module/some_klass']
          }
        end
4. Copy migration (currently, not needed)

        bundle exec rake ajax_validator:install:migrations
5. Run migration (currently, not needed)

        bundle exec rake db:migrate SCOPE=ajax_validator
6. Run seeds (currently, not needed)

        bundle exec rake ajax_validator:db:seed
7. Add to `config/routes.rb`

        mount AjaxValidator::Engine, at: '/ajax_validator'

## How to use helpers

Include the needed javascript file in your application.js or application.js.coffee

        Javascript
        //= require ajax_validator/application

        or CoffeeScript
        #= require ajax_validator/application

        Script will add class 'has-error' or 'has-success' to the field wrapping div, based on the result.

        Add these attributes on text input field:
            class: 'ajax_validator__field'
            data-form-object='validations/signup_form_company_name' [Optional, leave empty string '' to validate on model directly]
            data-resource-model='company'
            data-resource-attr-name='name'
            data-ignore-resource-attr-value='false' [Optional, set to 'true' when attribute is assembled from additional params instead]
            data-resource-instance-additional-params='{"something": true, "something_else": ""}' [Optional]

        Example on Bootstrap:

        ERB:
        <div class="input-group">
            <input class='form-control ajax_validator__field' data-form-object='validations/signup_form_company_name' data-resource-model='company' data-resource-attr-name='name' type='text' name='signup_form[company]' id='signup_form_company'>
        </div>

        or HAML:
        .input-group
            = f.text_field :company, class: 'form-control ajax_validator__field', data: {form_object: 'validations/signup_form_company_name', resource_model: 'company', resource_attr_name: 'name'}

### How to add a new gem to the engine
- Add a gem to `Gemfile`
- Run: `bundle`
- Copy over to multiple gemfiles: `bundle exec appraisal install`

### How to test
    cd vendor/engines/ajax_validator/
    bundle exec appraisal

    export DATABASE_URL='postgres://localhost:5432' AJAX_VALIDATOR_DATABASE_USERNAME=postgres AJAX_VALIDATOR_DATABASE_PASSWORD=p

    bundle exec appraisal rails-4.1 rake db:create db:migrate db:seed
    bundle exec appraisal rake spec
---
- Optional:

        bundle exec appraisal rails-4.1 rake db:schema:load RAILS_ENV=test
---

    bundle exec appraisal rails-4.1 rake spec

## How to develop
    gem 'ajax_validator', path: 'vendor/engines/ajax_validator'

    bundle exec rails g scaffold ajax_validator/post name:string --integration_tool=rspec --helper=false --assets=false
    bundle exec rake db:migrate