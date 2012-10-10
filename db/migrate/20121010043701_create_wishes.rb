class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.integer :user_id
      t.integer :gear_id
      t.string :url
      t.string :image_path
      t.string :note
      t.timestamps
    end
  end
end
