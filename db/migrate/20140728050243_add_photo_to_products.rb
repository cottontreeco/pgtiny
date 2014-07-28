class AddPhotoToProducts < ActiveRecord::Migration
  def change
    add_attachment :products, :photo
  end
end
