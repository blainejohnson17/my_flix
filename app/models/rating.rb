class Rating < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :value
  validates_numericality_of :value, only_integer: :true
  validates_inclusion_of :value, in: 1..5
  validates_uniqueness_of :video_id, scope: :user_id
end