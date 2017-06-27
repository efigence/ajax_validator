begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

#load 'rails/tasks/statistics.rake'

Bundler::GemHelper.install_tasks

Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }
require 'rspec/core'
require 'rspec/core/rake_task'
require 'appraisal'

task :default => :spec

# RSpec::Core::RakeTask.new(:spec)
RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')

desc 'Default'
task :default do
  if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
    #Rake::Task['app:db:test:prepare'].invoke
    Rake::Task['spec'].invoke
  else
    Rake::Task['appraise'].invoke
  end
end

task :appraise do
  exec 'appraisal install && appraisal rake'
end
