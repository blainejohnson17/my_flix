class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, order: 'created_at DESC', dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :queue_items, dependent: :destroy

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description

  delegate :name, to: :category, prefix: true

  def self.search_by_title(search_term)
    search_term.strip!
    search_term.blank? ? [] : \
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def average_rating
    if ratings.empty?
      return 0
    else
      average = 0  
      video_ratings = ratings.where('value > ?', 0)
      video_ratings.each { |rating| average += rating.value }
      (average /= video_ratings.count.to_f).round(2)
    end
  end
end