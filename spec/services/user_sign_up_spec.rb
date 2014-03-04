require 'spec_helper'

describe UserSignUp do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      
      let(:charge) { double(:charge, successful?: true) }
      let(:bob) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter: bob) }

      before { StripeWrapper::Charge.should_receive(:create) { charge } }

      after { ActionMailer::Base.deliveries.clear }

      it "is successful" do
        result = UserSignUp.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(result).to be_successful
      end

      it "saves new user to the database" do
        UserSignUp.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "sends email to the user" do
        UserSignUp.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq([User.first.email])
      end

      it "sends email that contains the users full name" do
        UserSignUp.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include(User.first.full_name)
      end

      it "makes the user a follower of the inviter" do
        UserSignUp.new(Fabricate.build(:user)).sign_up("some_stripe_token", invitation.token)
        expect(bob.followers).to include(User.last)
      end

      it "makes the inviter a follower of the user" do
        UserSignUp.new(Fabricate.build(:user)).sign_up("some_stripe_token", invitation.token)
        expect(User.last.followers).to include(bob)
      end

      it "expires the invitation token" do
        UserSignUp.new(Fabricate.build(:user)).sign_up("some_stripe_token", invitation.token)
        expect(invitation.reload.token).to be_nil
      end
    end

    context "with valid personal info and declined card" do

      let(:charge) { double(:charge, successful?: false, error_message: "Your card was declined.") }

      before { StripeWrapper::Charge.should_receive(:create) { charge } }

      it "is not successful" do
        result = UserSignUp.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(result).not_to be_successful
      end

      it "sets @error_message" do
        result = UserSignUp.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(result.error_message).to eq("Your card was declined.")
      end

      it "doesn't save new user to the database" do
        UserSignUp.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do

      it "is not successful" do
        result = UserSignUp.new(Fabricate.build(:user, email: nil)).sign_up("some_stripe_token", nil)
        expect(result).not_to be_successful
      end

      it "sets @error_message" do
        result = UserSignUp.new(Fabricate.build(:user, email: nil)).sign_up("some_stripe_token", nil)
        expect(result.error_message).to eq("Invalid user information. Please check the errors below.")
      end

      it "doesn't save new user to the database" do
        UserSignUp.new(Fabricate.build(:user, email: nil)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(0)
      end

      it "doesn't send an email" do
        UserSignUp.new(Fabricate.build(:user, email: nil)).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "doesn't charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        UserSignUp.new(Fabricate.build(:user, email: nil)).sign_up("some_stripe_token", nil)
      end
    end
  end
end