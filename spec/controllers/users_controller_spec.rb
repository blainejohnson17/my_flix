require 'spec_helper'

describe UsersController do

  describe "GET #new" do
    
    it "assigns new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do

    context "with valid attributes" do
      
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

    context "with invalid attributes" do

      before { post :create, user: Fabricate.attributes_for(:user, email: nil)  }

      after { ActionMailer::Base.deliveries.clear }

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

  describe "GET #show" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 2 }
    end
    it "assigns the requested user to @user" do
      set_current_user
      get :show, id: current_user.id
      expect(assigns(:user)).to eq(current_user)
    end

  end
end