class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  #lambda proc for descending ordering of reviews
  default_scope->{order('created_at DESC')}
  validates :remark, presence: true, length: {maximum: 140}
  validates :user_id, presence: true
  validates :product_id, presence: true
end
