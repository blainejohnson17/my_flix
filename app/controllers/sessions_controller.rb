class SessionsController < ApplicationController
  before_filter :require_sign_out, only: [:new, :create]

  def create
    user = User.find_by_email(params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, notice: "You are signed in!"
    else
      flash[:error] = "Invalid email or password."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You are signed out."
  end
end