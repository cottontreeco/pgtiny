require 'digest/sha2'

class User < ActiveRecord::Base
  has_many :wishs, :dependent => :destroy
  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates :password, :confirmation => true
  attr_accessor :password_confirmation
  attr_reader :password

  validate :password_must_be_present

  # hash the pwd
  def User.encrypt_password(pwd, salt)
      Digest::SHA2.hexdigest(pwd + "dribble" + salt)
  end

  # if the hashed pwd matches, return user object
  def User.authenticate(email, pwd)
    if user=find_by_email(email)
      if user.hashed_password == encrypt_password(pwd, user.salt)
        user
      end
    end
  end

  # a virtual assignment to save the hashed password
  # @param pwd [plain text pwd]
  def password=(pwd)
    @password = pwd #assign the instance var

    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(pwd, salt)
    end

  end

  private

  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def password_must_be_present
    errors.add(:password, "Missing password") unless hashed_password.present?
  end
end
