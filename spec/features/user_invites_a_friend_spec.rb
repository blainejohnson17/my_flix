require 'spec_helper'

feature "User invites a friend" do
  
  scenario "User successfully invites a friend and friend accepts invitation" do
    bob = Fabricate(:user)
    sign_in(bob)

    invite_a_friend
    friend_accepts_invitation

    friend_should_follow_inviter(bob)
    inviter_should_follow_friend(bob)
  end
  
  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Alice"
    fill_in "Friend's Email Address", with: "alice@example.com"
    fill_in "Message", with: "Come check out Myflix!"
    click_button "Send Invitation"
    expect(page).to have_content("Your invitation has been sent!")
    sign_out
  end

  def friend_accepts_invitation
    open_email('alice@example.com')
    current_email.click_link "Accept this invitation"
    expect(page).to have_field('Email Address', with: 'alice@example.com')
    fill_in "Password", with: 'password'
    fill_in "Full name", with: 'Alice Jones'
    save_and_open_page
    fill_in "Credit Card Number", with: '4242424242424242'
    fill_in "Security Code", with: '123'
    click_button "Sign Up"
    expect(page).to have_content('Welcome, Alice Jones')
  end

  def friend_should_follow_inviter(inviter)
    click_link "People"
    expect(page).to have_content inviter.full_name
    sign_out
  end

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content "Alice Jones"
  end
end