class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX },
                  uniqueness: { case_sensitive: false }
  
  has_secure_password
  
  validates :password, presence: true, length: { minimum: 6 }

  def User.digest(string)
    # this is what i think is happening for thist first line
    # its a ternary operator because of the question mark
    # so 'ActiveModel::SecurePassword.min_cost' must melt down
    # to a bool. and depending on that it decides to use
    # the min cost, or the normal cost that the system is already
    # set to.
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    # and then this is pretty self explanitory.
    BCrypt::Password.create(string, cost: cost)
  end
  
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
end