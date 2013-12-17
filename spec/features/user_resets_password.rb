require 'spec_helper'

feature "User resets password" do

  scenario "User successfully resets password" do
    
    bob = Fabricate(:user, password: 'old_password')
    
    visit sign_in_path
    click_link "Forgot Password"
    
    fill_in "email", with: bob.email
    click_button "Send Email"

    open_email(bob.email)
    current_email.click_link "Reset your password"
    
    fill_in "New Password", with: 'new_password'
    click_button "Reset Password"
    
    fill_in "Email Address", with: bob.email
    fill_in "Password", with: 'new_password'
    click_button "Sign in"
    
    expect(page).to have_content(bob.full_name)
  end
end