require 'spec_helper'

describe PasswordResetsController do

  describe "GET #show" do

    it "renders the show template if the token is valid" do
      bob = Fabricate(:user)
      get :show, id: bob.token
      expect(response).to render_template :show
    end

    it "redirects to the expired token page if the token is invalid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do

    context "with valid token" do

      let(:bob) { Fabricate(:user, password: 'old_password') }

      before { post :create, token: bob.token, password: 'new_password' }

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "updates the users password" do
        expect(User.find(bob.id).authenticate('new_password')).to eq(bob)
      end

      it "set flash notice" do
        expect(flash[:notice]).to eq('Your password has been updated.')
      end

      it "regenerates the users token" do
        expect(User.find(bob.id).token).to_not eq(bob.token)
      end
    end

    context "with invalid token" do

      it "redirect_to to the expired token page" do
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end