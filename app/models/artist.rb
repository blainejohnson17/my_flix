class Artist < ActiveRecord::Base
  has_many :actor_roles, dependent: :destroy
  has_many :acting_parts, through: :actor_roles, source: :video
  has_many :creator_roles, dependent: :destroy
  has_many :creatorships, through: :creator_roles, source: :video
end