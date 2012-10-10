class Gear < ActiveRecord::Base
  default_scope order: 'title'
  has_many :wishs, :dependent => :destroy
  before_destroy :ensure_not_referred_by_any_wishes

  validates :title, :category, :image_url, presence: true
  validates :title, uniqueness: true
  validates :image_url, format: {
      with: %r{\.(gif|jpg|png)$}i,
      message: 'must be a URL for GIF, JPG or PNG image.'
  }

  private
    def ensure_not_referred_by_any_wishes
      if wishs.empty?
        return true
      else
        errors.add(:base, 'Wishes present')
        return false
      end
    end
end
