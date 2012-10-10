class Wish < ActiveRecord::Base
  belongs_to :user
  belongs_to :gear
  validates :url, :presence => true
  validates :image_path, :presence => true
  validates :note, :presence => true
end
