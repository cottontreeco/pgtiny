class Relationship < ActiveRecord::Base
  #follower_id is not accessible
  attr_accessible :followed_id

  #there is no follower or followed model
  #must provide class name user
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
