require 'spec_helper'

describe Category do

  it { should have_many(:videos).order('created_at DESC') }
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do

    let(:comedy) { Fabricate(:category) }

    it "returns an array of 48 videos if there are 48 videos" do
      48.times do
        Fabricate(:video, category: comedy)
      end
      expect(comedy.recent_videos.count).to eq(48)
    end
    
    it "returns an array of 48 videos more than 48 videos" do
      49.times do
        Fabricate(:video, category: comedy)
      end
      expect(comedy.recent_videos.count).to eq(48)
    end

    it "returns all the video if there are less than 48 videos" do
      5.times do
        Fabricate(:video, category: comedy)
      end
      expect(comedy.recent_videos.count).to eq(5)
    end

    it "returns the videos in decending order of created_at" do
      ghost_busters = Fabricate(:video, title: "Ghost Busters", description: "Ghost Movie.", category: comedy)
      gooneys = Fabricate(:video, title: "Gooneys", description: "Adventure movie.", category: comedy, created_at: 1.day.ago)
      expect(comedy.recent_videos).to eq([ghost_busters, gooneys])
    end

    it "returns the most recent videos" do
      48.times do
        Fabricate(:video, category: comedy)
      end
      last_video = Fabricate(:video, title: "last movie", description: "This is the last movie created.", category: comedy, created_at: 1.day.ago)
      expect(comedy.recent_videos).not_to include(last_video)
    end

    it "returns on empty array when there are no videos" do
      expect(comedy.recent_videos).to eq([])
    end
  end
end