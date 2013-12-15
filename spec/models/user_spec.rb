require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should have_many(:queue_items).order(:position).dependent(:destroy) }
  it { should have_many(:reviews).order('created_at DESC').dependent(:destroy) }
  it { should have_many(:leading_relationships).class_name('Relationship').with_foreign_key('leader_id').dependent(:destroy) }
  it { should have_many(:followers).through(:leading_relationships) }
  it { should have_many(:leaders).through(:following_relationships) }
  it { should have_many(:following_relationships).class_name('Relationship').with_foreign_key('follower_id').dependent(:destroy) }
  it { should have_secure_password }

  it "generates a random token when a user is created" do
    bob = Fabricate(:user)
    expect(bob.token).to be_present
  end

  describe "#queued_video?" do

    it "should return true when the video is in the users queue" do
      current_user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: current_user, video: video)
      expect(current_user.queued_video?(video)).to eq(true)
    end

    it "should return false when the video is not in the users queue" do
      current_user = Fabricate(:user)
      expect(current_user.queued_video?(Fabricate(:video))).to eq(false)
    end
  end

  describe "#can_follow?" do

    it "returns false if the current user is the same as the proposed leader" do
      bob = Fabricate(:user)
      expect(bob.can_follow?(bob)).to be_false
    end

    it "returns false if the current user is already following the proposed leader" do
      bob = Fabricate(:user)
      alice = Fabricate(:user)
      Fabricate(:relationship, leader: alice, follower: bob)
      expect(bob.can_follow?(alice)).to be_false
    end

    it "returns true if user is allowed to follow proposed leader" do
      bob = Fabricate(:user)
      alice = Fabricate(:user)
      expect(bob.can_follow?(alice)).to be_true
    end
  end
end