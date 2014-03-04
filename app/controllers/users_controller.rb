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
    result = UserSignUp.new(@user).sign_up(params[:stripeToken], params[:invitation_token])

    if result.successful?
      session[:user_id] = @user.id
      redirect_to home_path, notice: 'Welcome to MyFLiX!'
    else
      flash[:error] = result.error_message
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