class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def require_user
    redirect_to sign_in_path unless current_user 
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def require_sign_out
    redirect_to home_path if current_user
  end

  def owner?(user)
    current_user == user
  end

  def access_denied
    flash[:error] = "You don't have proper permissions to do that."
    redirect_to home_path
  end
end
