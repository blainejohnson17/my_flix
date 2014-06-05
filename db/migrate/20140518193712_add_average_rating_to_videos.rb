class AddAverageRatingToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :average_rating, :float, default: 0
  end
end
