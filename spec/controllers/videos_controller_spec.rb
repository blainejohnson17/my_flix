require 'spec_helper'

describe VideosController do

  before { set_current_user }

  describe "GET #index" do

    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end

    it "sets @categories to all Categories" do
      get :index
      expect(assigns(:categories)).to eq(Category.all)
    end
  end

  describe "GET #show" do

    let(:video) { Fabricate(:video) }

    it_behaves_like "require sign in" do
      let(:action) { get :show, id: 3 }
    end

    it "assigns the requested video to @video"  do
      get :show, id: video
      expect(assigns(:video)).to eq(video)
    end

    it "assigns the reviews for the requested video to @reviews" do
      review1 = Fabricate(:review, video: video, user: Fabricate(:user))
      review2 = Fabricate(:review, video: video, user: Fabricate(:user))
      get :show, id: video
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
  end

  describe "GET #search" do

    it_behaves_like "require sign in" do
      let(:action) { get :search, term: 'go' }
    end

    it "assigns the results of search to @videos" do
      goonies = Fabricate(:video, title: 'Goonies')
      get :search, term: 'go'
      expect(assigns(:videos)).to eq([goonies])
    end
  end
end