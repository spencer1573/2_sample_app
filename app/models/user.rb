class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token
  # that just means search for and do those methods
  # before_save and 
  # before_create
  before_save   :downcase_email
  before_create :create_activation_digest
  
  # "we passed before_save an explicit block"
  # this site seems useful:
  # http://mudge.name/2011/01/26/passing-blocks-in-ruby-without-block.html
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX },
                  uniqueness: { case_sensitive: false }
  
  has_secure_password
  
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

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
  
  def authenticated?(attribute, token)
    # so because we are in the user model
    # we can ommit the self. in send (self.send(#{...)
    # send makes it the same as sending a method to 
    # i'm guessing user.
    # attribute makes it so that we can verify either 
    # the email token or the password token with authenitcated
    # i think.
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def activate 
    update_attribute(:activated,  true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  def send_activation_email
    #self is optional inside the model as a substitute for @user
    UserMailer.account_activation(self).deliver_now
  end
  
  private
    
    # downcases email
    def downcase_email
      self.email = email.downcase
    end
    
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
  
end