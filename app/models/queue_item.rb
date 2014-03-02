class QueueItem < ActiveRecord::Base
  validates_uniqueness_of :video_id, scope: :user_id
  validates_numericality_of :position, only_integer: :true

  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :name, to: :category, prefix: true
  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(video_id: video.id, user_id: user.id).first
    review.rating if review
  end
end