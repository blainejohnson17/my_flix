class RelationshipsController < ApplicationController
  before_filter :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def create
    leader = User.find(params[:leader_id])

    Relationship.create(leader: leader, follower: current_user) if current_user.can_follow?(leader)
    redirect_to people_path
  end

  def destroy
    relationship = current_user.following_relationships.find_by_id(params[:id])
    
    relationship.destroy if relationship
    redirect_to people_path
  end
end