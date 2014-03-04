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

    context "successful user sign up" do

      let(:result) { double(:sign_up_result, successful?: true) }

      before do
        UserSignUp.any_instance.should_receive(:sign_up) { result }
        User.any_instance.stub(:id) { 1 }
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "logs new user in" do
        expect(session[:user_id]).to eq(1)
      end

      it "sets the notice" do
        expect(flash[:notice]).not_to be_blank        
      end

      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end
    end

    context "failed user sign up" do

      let(:result) { double(:sign_up_result, successful?: false, error_message: "Error Message") }

      before do
        UserSignUp.any_instance.should_receive(:sign_up) { result }
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "renders :new template" do
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        expect(flash[:error]).to be_present
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