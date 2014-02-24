require 'spec_helper'

describe UsersController do

  describe "GET #show" do
    
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 2 }
    end
    
    it "assigns the requested user to @user" do
      set_current_user
      get :show, id: current_user.id
      expect(assigns(:user)).to eq(current_user)
    end
  end

  describe "GET #new" do

    it_behaves_like "requires sign out" do
      let(:action) { get :new }
    end

    it "assigns new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do

    after { ActionMailer::Base.deliveries.clear }

    it_behaves_like "requires sign out" do
      let(:action) { post :create }
    end

    context "with valid personal info and valid card" do

      let(:bob) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter: bob) }

      before do
        charge = double(:charge, successful?: true)
        StripeWrapper::Charge.should_receive(:create) { charge } 
      end

      it "saves new user to the database" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "logs new user in" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(session[:user_id]).to eq(User.first.id)
      end

      it "sets the notice" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(flash[:notice]).not_to be_blank        
      end

      it "redirects to home page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to home_path
      end

      it "sends email to the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(ActionMailer::Base.deliveries.last.to).to eq([User.first.email])
      end

      it "sends email that contains the users full name" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(ActionMailer::Base.deliveries.last.body).to include(User.first.full_name)
      end

      it "makes the user a follower of the inviter" do
        post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token
        expect(bob.followers).to include(User.last)
      end

      it "makes the inviter a follower of the user" do
        post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token
        expect(User.last.followers).to include(bob)
      end

      it "expires the invitation token" do
        post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token
        expect(invitation.reload.token).to be_nil
      end
    end

    context "with valid personal info and declined card" do

      before do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create) { charge } 
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "doesn't save new user to the database" do
        expect(User.count).to eq(0)
      end

      it "renders :new template" do
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        expect(flash[:error]).to be_present
      end
    end

    context "with invalid personal info" do

      it "doesn't save new user to the database" do
        post :create, user: Fabricate.attributes_for(:user, email: nil)
        expect(User.count).to eq(0)
      end

      it "renders :new template" do
        post :create, user: Fabricate.attributes_for(:user, email: nil)
        expect(response).to render_template :new
      end

      it "assigns new User to @user with params" do
        post :create, user: Fabricate.attributes_for(:user, email: nil)
        expect(assigns(:user)).to be_a_new(User)
      end

      it "doesn't send an email" do
        post :create, user: Fabricate.attributes_for(:user, email: nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "doesn't charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, user: Fabricate.attributes_for(:user, email: nil)
      end
    end
  end

  describe "GET #new_with_invitation_token" do

    it_behaves_like "requires sign out" do
      let(:action) { get :new_with_invitation_token, invitation_token: 3 }
    end

    context "with valid invitation token" do

      it "renders the :new template" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, invitation_token: invitation.token
        expect(response).to render_template :new
      end

      it "sets @user to new User with email attribute set to recipient's" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, invitation_token: invitation.token
        expect(assigns(:user).email).to eq(invitation.recipient_email)
      end
    end

    context "with invalid invitation token" do

      it "redirects to the register_path" do
        get :new_with_invitation_token, invitation_token: "12345"
        expect(response).to redirect_to register_path
      end
    end
  end
end