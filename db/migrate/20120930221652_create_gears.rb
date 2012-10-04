class CreateGears < ActiveRecord::Migration
  def change
    create_table :gears do |t|
      t.string :title
      t.string :image_url
      t.string :category

      t.timestamps
    end
  end
end
