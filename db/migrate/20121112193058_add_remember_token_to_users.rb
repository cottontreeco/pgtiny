class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_token, :string
    add_index :users, :remember_token
    remove_column :users, :salt
    remove_column :users, :hashed_password
  end
end
