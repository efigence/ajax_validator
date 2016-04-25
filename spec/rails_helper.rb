# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

#~FIX
#require File.expand_path('../../config/environment', __FILE__)
require File.expand_path('../dummy/config/environment.rb',  __FILE__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

#~ADD
# require 'ajax_validator' NEEDED?
require 'factory_girl_rails'
require 'route_helper'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#

# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), '/support/**/*.rb')].each { |f| require f }
# https://github.com/eliotsykes/rspec-rails-examples/tree/master/spec/support

RSpec.configure do |config|
  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace('gem name')

  #~ADD
  config.infer_base_class_for_anonymous_controllers = false
  config.include RouteHelper, type: :routing
  config.include RouteHelper, type: :controller
end

#~ADD
Rails.backtrace_cleaner.remove_silencers!
ActiveRecord::Migration.maintain_test_schema!
