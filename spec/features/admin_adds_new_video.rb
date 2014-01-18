require 'spec_helper'

feature "Admin adds new video" do
  
  scenario "Admin successfully adds a new video" do
    
    admin = Fabricate(:admin)
    sign_in(admin)
    dramas = Fabricate(:category, name: "Dramas")
    visit new_admin_video_path
    fill_in "Title", with: "Monk"
    select "Dramas", from: "Category"
    fill_in "Description", with: "Great Movie"
    attach_file "Large cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small cover", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "http://www.example.com/my_video.mp4"
    click_button "Add Video"

    sign_out
    sign_in

    visit home_path
    expect(page).to have_selector("img[src='/uploads/monk.jpg']")
    
    find(:xpath, "//a[@href='/videos/1']").click
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/my_video.mp4']")
  end
end