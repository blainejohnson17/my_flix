require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should have_many(:reviews).order("created_at DESC").dependent(:destroy) }
  it { should have_many(:queue_items).dependent(:destroy) }
  it { should have_many(:actor_roles).dependent(:destroy) }
  it { should have_many(:actors).through(:actor_roles) }
  it { should have_many(:creator_roles).dependent(:destroy) }
  it { should have_many(:creators).through(:creator_roles) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search_by_title" do

    let(:gooneys) { Fabricate(:video, title: "Gooneys", description: "Adventure movie.", created_at: 1.day.ago) }
    let(:ghost_busters) { Fabricate(:video, title: "Ghost Busters", description: "Ghost Movie.") }

    it "returns an empty array if no match is found" do
      expect(Video.search_by_title("Monk")).to eq([])
    end

    it "returns an array of one video for a single exact match" do
      expect(Video.search_by_title("Gooneys")).to eq([gooneys])
    end

    it "returns an array of one video for a single partial match" do
      expect(Video.search_by_title("Goon")).to eq([gooneys])
    end

    it "returns an array of multiple videos for multple parital matches ordered by created_at desc" do
      expect(Video.search_by_title("G")).to eq([ghost_busters, gooneys])
    end

    it "returns an empty array for a search of an empty string" do
      expect(Video.search_by_title("")).to eq([])
    end

    it "returns an empty string if search term only contains white space" do
      expect(Video.search_by_title(" ")).to eq([])
      expect(Video.search_by_title("  ")).to eq([])
    end
  end

  describe "#calculate_average_rating" do

    let(:video) { Fabricate(:video) }
    let(:bob) { Fabricate(:user) }
    let(:alice) { Fabricate(:user) }
    let(:joe) { Fabricate(:user) }

    it "returns 0 if there are no ratings" do
      expect(video.calculate_average_rating).to eq(0)
    end

    it "returns the rating when there is 1 review" do
      rating = Fabricate(:rating, video: video)
      expect(video.calculate_average_rating).to eq(rating.value)
    end

    it "returns the average of all ratings when there are more than one reviews" do
      Fabricate(:rating, video: video, value: 2, user: bob)
      Fabricate(:rating, video: video, value: 3, user: alice)
      expect(video.reload.calculate_average_rating).to eq(2.5)
    end

    it "returns the average with up to 2 decimal places of precision" do
      Fabricate(:rating, video: video, value: 1, user: bob)
      Fabricate(:rating, video: video, value: 1, user: alice)
      Fabricate(:rating, video: video, value: 2, user: joe)
      expect(video.reload.calculate_average_rating).to eq(1.33)
    end
  end

  describe "#update_average_rating" do
    it "updates the average_rating value in the db" do
      video = Fabricate(:video)
      Fabricate(:rating, video: video)
      expect(video.average_rating).to eq(video.calculate_average_rating)
    end
  end
end