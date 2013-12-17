require 'spec_helper'

describe InvitationsController do

  describe "GET #new" do

    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end

    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
  end

  describe "POST #create" do

    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end

    context "with valid input" do

      it "redirects the new invitation page" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe", recipient_email: "joe@example.com", message: "Joe, you should check out this site!" }
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe", recipient_email: "joe@example.com", message: "Joe, you should check out this site!" }
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe", recipient_email: "joe@example.com", message: "Joe, you should check out this site!" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "sets the flash success message" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe", recipient_email: "joe@example.com", message: "Joe, you should check out this site!" }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do

      before { ActionMailer::Base.deliveries.clear }

      it "render the new template" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe", recipient_email: "joe@example.com" }
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe", recipient_email: "joe@example.com" }
        expect(Invitation.count).to eq(0)
      end

      it "does not send an email" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe", recipient_email: "joe@example.com" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the flash error message" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe", recipient_email: "joe@example.com" }
        expect(flash[:error]).to be_present
      end

      it "sets @invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe", recipient_email: "joe@example.com" }
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end