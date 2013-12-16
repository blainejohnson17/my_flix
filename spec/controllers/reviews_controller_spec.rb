require 'spec_helper'

describe ReviewsController do
  
  before { set_current_user }

  describe "POST #create" do

    let(:video) { Fabricate(:video) }

    it_behaves_like "require sign in" do
      let(:action) { post :create, review: Fabricate.attributes_for(:review), video_id: 3 }
    end

    context "with valid input" do

      before { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }

      it "redirects to video show page" do
        expect(response).to redirect_to video
      end

      it "saves new review to the database" do
        expect(Review.count).to eq(1)
      end

      it "creates review associated to the video" do
        expect(Review.first.video).to eq(video)
      end

      it "creates review associated with the signed in user" do
        expect(Review.first.user).to eq(current_user)
      end

      it "sets notice" do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "with invalid input" do

      it "does not save the new review to the database" do
        post :create, review: {rating: "i"}, video_id: video.id
        expect(Review.count).to eq(0)
      end

      it "renders the videos/show template" do
        post :create, review: {rating: "i"}, video_id: video.id
        expect(response).to render_template "videos/show"
      end

      it "sets @video" do
        post :create, review: {rating: "i"}, video_id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "sets @reviews" do
        review = Fabricate(:review, video: video)
        post :create, review: {rating: "i"}, video_id: video.id
        expect(assigns(:reviews)).to match_array([review])
      end

      it "sets notice" do
        post :create, review: {rating: "i"}, video_id: video.id
        expect(flash[:error]).not_to be_blank
      end
    end
  end
end