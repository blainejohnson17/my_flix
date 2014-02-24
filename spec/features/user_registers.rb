require 'spec_helper'

feature "User registers", {vcr: true, js: true} do

  background { visit register_path }

  scenario "with valid user info and valid card" do
    fill_in_valid_user_info
    fill_in_card_info('4242424242424242')
    click_button "Sign Up"

    expect(page).to have_content('Welcome to MyFLiX!')

  end

  scenario "with valid user info and invalid card" do
    fill_in_valid_user_info
    fill_in_card_info('123')
    click_button "Sign Up"

    expect(page).to have_content('This card number looks invalid')    
  end

  scenario "with valid user info and declined card" do
    fill_in_valid_user_info
    fill_in_card_info('4000000000000002')
    click_button "Sign Up"

    expect(page).to have_content('Your card was declined.')    
  end

  scenario "with invalid user info and valid card" do
    fill_in_invalid_user_info
    fill_in_card_info('4242424242424242')
    click_button "Sign Up"

    expect(page).to have_content('Invalid user information. Please check the errors below.')    
  end

  scenario "with invalid user info and invalid card" do
    fill_in_invalid_user_info
    fill_in_card_info('123')
    click_button "Sign Up"

    expect(page).to have_content('This card number looks invalid')    
  end

  scenario "with invalid user info and declined card" do
    fill_in_invalid_user_info
    fill_in_card_info('4000000000000002')
    click_button "Sign Up"

    expect(page).to have_content('Invalid user information. Please check the errors below.')    
  end

  def fill_in_valid_user_info
    fill_in "Email Address", with: "john@example.com"
    fill_in "Password", with: "secret"
    fill_in "Full name", with: "John Doe"
  end

  def fill_in_invalid_user_info
    fill_in "Email Address", with: "john@example.com"
  end

  def fill_in_card_info(card_number)
    fill_in "Credit Card Number", with: card_number
    fill_in "Security Code", with: "123"
    select "5 - May", from: "date_month"
    select "2016", from: "date_year"
  end
end