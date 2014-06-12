class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  #lambda proc for descending ordering of reviews
  default_scope->{order('created_at DESC')}
  validates :remark, presence: true, length: {maximum: 140}
  validates :user_id, presence: true
  validates :product_id, presence: true

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id=:user_id"
    where("user_id IN (#{followed_user_ids}) or user_id=:user_id",
          user_id: user.id)
  end
end
