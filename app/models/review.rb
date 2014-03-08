class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :content
  validates_uniqueness_of :video_id, scope: :user_id

  def rating
    rating = Rating.where(video_id: video.id, user_id: user.id).first
    rating.value if rating
  end
end