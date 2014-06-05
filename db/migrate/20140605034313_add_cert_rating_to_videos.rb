class AddCertRatingToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :cert_rating, :string
  end
end
