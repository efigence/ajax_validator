require "rails_helper"

# https://www.amberbit.com/blog/2015/10/15/rails-mountable-engines/
# http://stackoverflow.com/questions/33754450/rspec-with-capybara-sometimes-not-pass-tests
RSpec.feature "Engine management", :type => :feature do
  scenario "User makes a request", js: true do

    # TODO:
    visit '/base'
    #visit "/ajax_validator/validators"

    fill_in "Name", :with => "Bad boy"
    #click_button "Create Widget"

    expect(page).to have_text("Name is evil", wait: 5.0)
  end
end
