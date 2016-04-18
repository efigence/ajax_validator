$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'ajax_validator/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'ajax_validator'
  s.version     = AjaxValidator::VERSION
  s.authors     = ['Marcin Kalita']
  s.email       = ['rubyconvict@gmail.com']
  s.homepage    = "https://github.com/efigence/ajax_validator"
  s.summary     = %q{Ajax Live Form Validation Rails Engine}
  s.description = %q{Ajax Validator is a Rails engine that allows to validate form fields.}
  s.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  s.files         = Dir['{app,config,db,lib}/**/*', 'spec/factories/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  #s.files         = `git ls-files`.split("\n")
  s.test_files    = Dir['spec/**/*']
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.bindir     = "exe"
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  #s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency('rake')
  s.add_runtime_dependency('bundler')
  s.add_runtime_dependency('rails')
  s.add_runtime_dependency('jquery-rails')
  s.add_runtime_dependency('coffee-rails')

  s.add_development_dependency('pg')
  s.add_development_dependency('byebug')
  s.add_development_dependency('pry')
  s.add_development_dependency('pry-byebug')
  s.add_development_dependency('factory_girl_rails')
  s.add_development_dependency('rspec-rails')
  s.add_development_dependency('cucumber_scaffold')

  s.add_development_dependency('cucumber-rails', ['>= 1.4.0'])
  s.add_development_dependency('database_cleaner')
  s.add_development_dependency('formulaic')
  s.add_development_dependency('poltergeist')
  s.add_development_dependency('fuubar')
  s.add_development_dependency('capybara-puma')
  s.add_development_dependency('capybara-screenshot')
end
