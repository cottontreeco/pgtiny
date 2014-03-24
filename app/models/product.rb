class Product < ActiveRecord::Base
  #destroying product will also remove the reviews
  has_many :reviews, dependent: :destroy
  validates :name, presence: true, length: {maximum: 64},
            uniqueness: {case_sensitive: false }
end
