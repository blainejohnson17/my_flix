require 'spec_helper'

feature "User updates account info" do

  given(:alice) { Fabricate(:user, email: "old_email@example.com", full_name: "Alice Jones") }

  background { sign_in }

  scenario "User updates there full name" do

    click_link "Account"

    fill_in "Full name", with: "Alice Johnson"
    fill_in "Password", with: alice.password
    click_button "Update"

    expect(page).to have_content("Alice Johnson")
  end
end