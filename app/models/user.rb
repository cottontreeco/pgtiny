require 'digest/sha2'

class User < ActiveRecord::Base
  has_many :wishs, dependent: :destroy
  attr_accessible :name, :email, :password,:password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy

  # specify foreign key column name to override the default "relationship_id"
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  #specify the source of the user id via followed_id
  has_many :followed_users, through: :relationships, source: :followed

  # specify class name to reuse existing relationship table with different id
  # otherwise a ReverseRelationship class does not exist
  has_many :reverse_relationships, foreign_key: "followed_id",
           class_name: "Relationship", dependent: :destroy
  #specify the source of the user id via follower_id
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save {self.email.downcase!}
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6}, confirmation: true
  validates :password_confirmation, presence: true

  def feed
    #Preliminary
    #question mark is to escape the id value
    #to avoid SQL injection
    #Micropost.where("user_id=?", id)
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    self.relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    self.relationships.find_by_followed_id(other_user.id).destroy
  end
  #attr_accessor :password_confirmation, :name, :email
  #attr_reader :password

  #validate :password_must_be_present

  # hash the pwd
  #def User.encrypt_password(pwd, salt)
  #    Digest::SHA2.hexdigest(pwd + "dribble" + salt)
  #end

  # if the hashed pwd matches, return user object
  #def User.authenticate(email, pwd)
  #  if user=find_by_email(email)
  #    if user.hashed_password == encrypt_password(pwd, user.salt)
  #      user
  #    end
  #  end
  #end

  # a virtual assignment to save the hashed password
  # @param pwd [plain text pwd]
  #def password=(pwd)
  #  @password = pwd #assign the instance var
  #
  #  if password.present?
  #    generate_salt
  #    self.hashed_password = self.class.encrypt_password(pwd, salt)
  #  end
  #
  #end

  private
    def create_remember_token
      #create the token
      self.remember_token = SecureRandom.urlsafe_base64
    end
  #def generate_salt
  #  self.salt = self.object_id.to_s + rand.to_s
  #end

  #def password_must_be_present
  #  errors.add(:password, "Missing password") unless hashed_password.present?
  #end
end
