class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, order: 'created_at DESC', dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :queue_items, dependent: :destroy
  has_many :actor_roles, dependent: :destroy
  has_many :actors, through: :actor_roles, source: :artist
  has_many :creator_roles, dependent: :destroy
  has_many :creators, through: :creator_roles, source: :artist

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description

  delegate :name, to: :category, prefix: true

  self.per_page = 48

  def self.search_by_title(search_term)
    search_term.strip!
    search_term.blank? ? [] : \
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def calculate_average_rating
    reload
    if ratings.empty?
      return 0
    else
      average = 0
      ratings.each { |rating| average += rating.value }
      (average / ratings.count.to_f).round(2)
    end
  end

  def update_average_rating
    update_attribute(:average_rating, calculate_average_rating)
  end
end