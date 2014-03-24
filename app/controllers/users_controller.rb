class UsersController < ApplicationController
  before_filter :set_user, only: [:show, :edit, :update]
  before_filter :require_user, only: [:show]
  before_filter :require_owner, only: [:edit, :update]
  before_filter :require_sign_out, only: [:new, :create, :new_with_invitation_token]

  def show
  end

  def new
    @user = User.new
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

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, notice: "Your account info was successfully updated!"
    else
      flash[:error] = "Please fix the errors below."
      render :edit
    end
  end

  private

  def set_user
    @user = User.where(id: params[:id]).first
  end

  def require_owner
    access_denied unless owner?(@user)
  end

  def user_params
    params.require(:user).permit(:email, :full_name, :password)
  end
end