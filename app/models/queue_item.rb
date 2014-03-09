class QueueItem < ActiveRecord::Base
  validates_uniqueness_of :video_id, scope: :user_id
  validates_numericality_of :position, only_integer: :true

  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :category_name, to: :video
  delegate :title, to: :video, prefix: true

  def rating
    rating = Rating.where(video_id: video.id, user_id: user.id).first
    rating.value if rating
  end
end