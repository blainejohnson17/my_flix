class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])

    if user
      AppMailer.send_forgot_password_email(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = params[:email].blank? ? "You must enter your email address." : "We can't find a user with the email you provided."
      redirect_to forgot_password_path
    end
  end
end