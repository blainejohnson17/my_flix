class PasswordResetsController < ApplicationController
  def show
    user = User.find_by_token(params[:id])
    redirect_to expired_token_path unless user
  end

  def create
    user = User.find_by_token(params[:token])

    if user
      user.password = params[:password]
      user.generate_token
      user.save
      redirect_to sign_in_path, notice: "Your password has been updated."
    else
      redirect_to expired_token_path
    end
  end
end