require 'spec_helper'

describe ForgotPasswordsController do

  describe "POST #create" do

    context "with blank input" do

      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it "sets error message" do
        post :create, email: ''
        expect(flash[:error]).to eq("You must enter your email address.")
      end
    end

    context "with existing email" do

      it "should redirect to the forgot password confirmation page" do
        bob = Fabricate(:user)
        post :create, email: bob.email
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "should send an email to the email address" do
        bob = Fabricate(:user)
        post :create, email: bob.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([bob.email])
      end
    end

    context "with non-existing email" do

      it "redirects to the forgot password page" do
        post :create, email: "joe@example.com"
        expect(response).to redirect_to forgot_password_path
      end

      it "sets error message" do
        post :create, email: "joe@example.com"
        expect(flash[:error]).to eq("We can't find a user with the email you provided.")
      end
    end
  end
end