class UsersController < ApplicationController
  before_filter :require_user, only: [:show]
  before_filter :require_sign_out, only: [:new, :create, :new_with_invitation_token]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    invitation = Invitation.find_by_token(params[:invitation_token])

    if @user.save
      AppMailer.send_welcome_email(@user).deliver
      session[:user_id] = @user.id
      if invitation
        @user.leaders << invitation.inviter
        @user.followers << invitation.inviter
        invitation.update_column(:token, nil)
      end
      redirect_to home_path, notice: 'You have successfully registered!'
    else
      render :new
    end
  end

  def new_with_invitation_token
    invitation = Invitation.find_by_token(params[:invitation_token])
    
    if invitation
      @user = User.new(email: invitation.recipient_email)
      render :new
    else
      redirect_to register_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :full_name, :password)
  end
end