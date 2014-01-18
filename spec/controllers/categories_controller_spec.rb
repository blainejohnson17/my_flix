require 'spec_helper'

describe CategoriesController do

  describe "GET #show" do

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets @category to the requested Category" do
      set_current_user
      commedy = Fabricate(:category)
      get :show, id: commedy.id
      expect(assigns(:category)).to eq(commedy)
    end
  end
end