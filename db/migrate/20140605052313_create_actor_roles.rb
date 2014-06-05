class CreateActorRoles < ActiveRecord::Migration
  def change
    create_table :actor_roles do |t|
      t.integer :video_id
      t.integer :artist_id
 
      t.timestamps
    end
  end
end
