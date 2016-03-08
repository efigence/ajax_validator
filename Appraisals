rails_versions = ['~> 4.1.0', '~> 4.2.0']

rails_versions.each do |rails_version|
  appraise "rails-#{rails_version.slice(/\d+\.\d+/)}" do
    gem 'rails', rails_version
    group :test do
      gem 'cucumber-rails', :require => false
    end
  end
end
