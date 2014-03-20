class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :content
      t.integer :user_id
      t.integer :product_id

      t.timestamps
    end
    add_index :reviews, [:user_id, :created_at], name: 'by_user_created_time'
    add_index :reviews, [:product_id, :created_at], name: 'by_product_created_time'
    add_index :reviews, [:product_id, :user_id], unique: true, name: 'by_user_product'
  end
end
