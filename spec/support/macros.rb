def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_admin(a_admin=nil)
  session[:user_id] = (a_admin || Fabricate(:admin)).id
end

def current_user
  @current_user ||= User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(user=nil)
  user ||= Fabricate(:user)
  visit sign_in_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_out
  visit sign_out_path
end

def click_video_on_home_page(video)
  visit home_path
  find("a[href='/videos/#{video.id}']").click
end