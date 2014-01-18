class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, order: 'created_at DESC', dependent: :destroy
  has_many :queue_items, dependent: :destroy

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    search_term.strip!
    search_term.blank? ? [] : \
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def average_rating
    if reviews.empty?
      return 0
    else
      average = 0  
      reviews.each { |review| average += review.rating }
      (average /= reviews.count.to_f).round(2)
    end
  end
end