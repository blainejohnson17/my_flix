class UserSignUp

  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
          :amount => 999,
          :card => stripe_token,
          :description => "Myflix membership payment for #{@user.email}."
        )
      if charge.successful?
        @user.save
        handle_invitation(invitation_token)
        AppMailer.delay.send_welcome_email(@user)
        @status = :success
      else
        @status = :failed
        @error_message = charge.error_message
      end
    else
      @status = :failed
      @error_message = "Invalid user information. Please check the errors below."
    end
    self
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    invitation = Invitation.find_by_token(invitation_token)
    if invitation
      @user.leaders << invitation.inviter
      @user.followers << invitation.inviter
      invitation.update_column(:token, nil)
    end    
  end
end