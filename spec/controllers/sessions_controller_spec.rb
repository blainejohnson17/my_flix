require 'spec_helper'

describe SessionsController do
  
  describe "GET #new" do

    it_behaves_like "require sign out" do
      let(:action) { get :new }
    end

    it "redirects to home page for athenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end

    it "renders :new template for unathenticated users" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do

    let(:bob) { Fabricate(:user) }

    it_behaves_like "require sign out" do
      let(:action) { post :create }
    end    

    context "with valid credentials" do

      before { post :create, email: bob.email, password: bob.password }

      it "saves user id in session" do
        expect(session[:user_id]).to eq(bob.id)
      end

      it "sets notice" do
        expect(flash[:notice]).not_to be_blank
      end

      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid credentials" do

      before { post :create, email: bob.email, password: "wrong" }

      it "doesn't save user id in session" do
        expect(session[:user_id]).to be_blank
      end

      it "sets notice" do
        expect(flash[:error]).not_to be_blank
      end

      it "renders :new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #destroy" do

    before do
      get :destroy
    end

    it "sets user id in the session to nil" do
      expect(session[:user_id]).to be_blank
    end

    it "sets notice" do
      expect(flash[:notice]).not_to be_blank  
    end

    it "redirects to front page" do
      expect(response).to redirect_to root_path
    end
  end
end