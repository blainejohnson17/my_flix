require 'spec_helper'

describe QueueItem do

  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }
  it { should validate_numericality_of(:position).only_integer }

  describe "#video_title" do

    it "returns the title of the associated video" do
      video = Fabricate(:video, title: 'Gooneys')
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Gooneys")
    end
  end

  describe "#rating" do

    let(:current_user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, user: current_user, video: video) }

    it "returns the rating of the associated video created by the current_user" do
      Fabricate(:rating, user: current_user, video: video, value: 5)
      expect(queue_item.rating).to eq(5)
    end

    it "returns nil when the current_user has not rated the associated video" do
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#category_name" do

    it "return the category name of the associated video" do
      category = Fabricate(:category, name: 'Comedy')
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq('Comedy')
    end
  end

  describe "#category" do

    it "returns the category object associated with the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)      
    end
  end
end