class CreateRatings < ActiveRecord::Migration
  def up
    create_table :ratings do |t|
      t.integer :value
      t.integer :user_id
      t.integer :video_id
      t.timestamps
    end

    remove_column :reviews, :rating
  end

  def down
    drop_table :ratings

    add_column :reviews, :rating, :integer
  end
end
