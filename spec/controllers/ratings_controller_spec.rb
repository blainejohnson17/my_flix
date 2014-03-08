require 'spec_helper'

describe RatingsController do

  describe "#update_rating" do

    before { set_current_user }

    let(:video) { Fabricate(:video) }

    it_behaves_like "requires sign in" do
      let(:action) { post :update_rating }
    end

    it "renders nothing" do
      post :update_rating, video_id: video.id, rating: 3
      expect(response.body).to eq(" ")
    end

    context "with rating value equal than 0" do

      it "doesn't save new rating to the database when value is 0" do
        post :update_rating, video_id: video.id, rating: 0
        expect(Rating.count).to eq(0)          
      end

      it "deletes existing rating" do
        rating = Fabricate(:rating, video: video, value: 3, user: current_user)
        post :update_rating, video_id: video.id, rating: 0
        expect(Rating.count).to eq(0)        
      end
    end

    context "with rating value greater than 0" do

      it "saves new rating to the database" do
        post :update_rating, video_id: video.id, rating: 3
        expect(Rating.count).to eq(1)
      end

      it "saves new rating associated to the current user" do
        post :update_rating, video_id: video.id, rating: 3
        expect(Rating.first.user).to eq(current_user)
      end

      it "saves new rating associated to the video" do
        post :update_rating, video_id: video.id, rating: 3
        expect(Rating.first.video).to eq(video)
      end

      it "updates existing rating with new value" do
        rating = Fabricate(:rating, video: video, value: 1, user: current_user)
        post :update_rating, video_id: video.id, rating: 3
        expect(rating.reload.value).to eq(3)
      end
    end
  end
end