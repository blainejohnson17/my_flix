class InvitationsController < ApplicationController
  before_filter :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)

    if @invitation.save
      AppMailer.delay.send_invitation_email(@invitation)
      flash[:success] = "Your invitation has been sent!"
      redirect_to new_invitation_path
    else
      flash.now[:error] = "Something went wrong."
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message).merge!(inviter_id: current_user.id)
  end
end