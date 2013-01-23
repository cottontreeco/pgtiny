class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    #expect retrieve posts by a given user
    #in reverse order of creation
    add_index :microposts, [:user_id, :created_at]
  end
end
