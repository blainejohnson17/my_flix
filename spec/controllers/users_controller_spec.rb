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

    it_behaves_like "requires sign out" do
      let(:action) { post :create }
    end

    context "with valid input and no invitation token" do
      
      before { post :create, user: Fabricate.attributes_for(:user) }

      it "saves new user to the database" do
        expect(User.count).to eq(1)
      end

      it "logs new user in" do
        expect(session[:user_id]).to eq(User.first.id)
      end

      it "sets the notice" do
        expect(flash[:notice]).not_to be_blank        
      end

      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end

      it "sends email to the user" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([User.first.email])
      end

      it "sends email that contains the users full name" do
        expect(ActionMailer::Base.deliveries.last.body).to include(User.first.full_name)
      end
    end

    context "with valid input and valid invitation token" do

      let(:bob) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter: bob) }

      before { post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token }

      it "saves new user to the database" do
        expect(User.count).to eq(2)
      end

      it "logs new user in" do
        expect(session[:user_id]).to eq(User.last.id)
      end

      it "sets the notice" do
        expect(flash[:notice]).not_to be_blank        
      end

      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end

      it "sends email to the user" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([User.last.email])
      end

      it "sends email that contains the users full name" do
        expect(ActionMailer::Base.deliveries.last.body).to include(User.last.full_name)
      end

      it "makes the user a follower of the inviter" do
        expect(bob.followers).to include(User.last)
      end

      it "makes the inviter a follower of the user" do
        expect(User.last.followers).to include(bob)
      end

      it "expires the invitation token" do
        expect(invitation.reload.token).to be_nil
      end
    end

    context "with invalid input" do

      before do 
        post :create, user: Fabricate.attributes_for(:user, email: nil)
        ActionMailer::Base.deliveries.clear
      end

      it "doesn't save new user to the database" do
        expect(User.count).to eq(0)
      end

      it "renders :new template" do
        expect(response).to render_template :new
      end

      it "assigns new User to @user with params" do
        expect(assigns(:user)).to be_a_new(User)
      end

      it "doesn't send an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
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