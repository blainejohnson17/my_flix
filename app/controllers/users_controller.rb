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

    if @user.valid?
      charge = StripeWrapper::Charge.create(
          :amount => 999,
          :card => params[:stripeToken],
          :description => "Myflix membership payment for #{@user.email}."
        )
      if charge.successful?
        @user.save
        handle_invitation
        AppMailer.delay.send_welcome_email(@user)
        session[:user_id] = @user.id
        redirect_to home_path, notice: 'Welcome to MyFLiX!'
      else
        flash[:error] = charge.error_message
        render :new
      end
    else
      flash[:error] = "Invalid user information. Please check the errors below."
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

  def handle_invitation
    invitation = Invitation.find_by_token(params[:invitation_token])
    if invitation
      @user.leaders << invitation.inviter
      @user.followers << invitation.inviter
      invitation.update_column(:token, nil)
    end    
  end
end