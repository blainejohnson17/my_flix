require 'spec_helper' 

describe RelationshipsController do

  describe "GET #index" do

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    it "sets @relationships to current users following relationships" do
      set_current_user
      relationship = Fabricate(:relationship, leader: Fabricate(:user), follower: current_user)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
  end

  describe "DELETE #destroy" do

    before { set_current_user }

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 3 }
    end

    it "redirects to the people page" do
      relationship = Fabricate(:relationship, leader: Fabricate(:user), follower: current_user)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it "destroys the current users following relationship" do
      relationship = Fabricate(:relationship, leader: Fabricate(:user), follower: current_user)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end

    it "does not destroy other users following relationships" do
      other_user = Fabricate(:user)
      leader = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: leader, follower: other_user)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
  end

  describe "POST #create" do

    let(:leader) { Fabricate(:user) }

    before { set_current_user }

    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 3 }
    end

    it "redirects to the people page" do
      post :create, leader_id: leader.id
      expect(response).to redirect_to people_path
    end

    it "saves new relationship" do
      post :create, leader_id: leader.id
      expect(Relationship.count).to eq(1)
    end

    it "creates a new relationship with the current_user as the follower" do
      post :create, leader_id: leader.id
      expect(leader.followers.first).to eq(current_user)
    end

    it "creates a new relationship with the specified user as the leader" do
      post :create, leader_id: leader.id
      expect(current_user.leaders.first).to eq(leader)      
    end

    it "doesn't create a relationship with the current_user as the leader" do
      post :create, leader_id: current_user.id
      expect(Relationship.count).to eq(0)      
    end

    it "doesn't create a duplicate relationship" do
      Fabricate(:relationship, leader: leader, follower: current_user)
      post :create, leader_id: leader
      expect(Relationship.count).to eq(1)
    end
  end
end