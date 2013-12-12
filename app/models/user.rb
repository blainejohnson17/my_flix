class User < ActiveRecord::Base
  has_many :queue_items, order: 'position', dependent: :destroy
  has_many :reviews, order: 'created_at DESC', dependent: :destroy
  has_many :leading_relationships, class_name: "Relationship", :foreign_key => "leader_id"
  has_many :followers, through: :leading_relationships, source: :follower
  has_many :following_relationships, class_name: "Relationship", :foreign_key => "follower_id"
  has_many :leaders, through: :following_relationships, source: :leader

  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :password, presence: true
  
  has_secure_password

  before_create :generate_token

  def normalize_queue_items_positions
    queue_items.each_with_index do |qi, index|
      qi.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    !queue_items.where(video_id: video.id).empty?
  end

  def can_follow?(another_user)
    !(self.leaders.include?(another_user) || self == another_user)
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end