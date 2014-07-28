class User < ActiveRecord::Base
  #destroying user will also remove the reviews
  has_many :reviews, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id",
           class_name: "Relationship", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower
  before_save { self.email=email.downcase}
  before_create :create_remember_token
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false }
  validates :password, length: {minimum: 6}
  has_secure_password

  # associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar,
                    styles: {
                      small: '64x64>',
                      thumb: '100x100#',
                      square: '200x200>'},
                    default_url: "/assets/:style/missing-avatar.png" ,
                    bucket: 'pgtiny',
                    s3_credentials: {
                        bucket: 'pgtiny',
                        access_key_id: 'AKIAIUFE4OUOQVKQ4WEA',
                        secret_access_key: '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'
                    }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def reviewer_feed
    # this gets all reviews from followings
    # Review.where(user_id: id)
    Review.from_users_followed_by(self)
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def following?(other_user)
    self.relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    self.relationships.find_by(followed_id: other_user.id).destroy
  end

private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
