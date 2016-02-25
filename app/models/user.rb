class User < ActiveRecord::Base
  # this sets up getters and setters for these three methods in the
  # class User see
  # http://stackoverflow.com/questions/4370960/what-is-attr-accessor-in-ruby
  attr_accessor :remember_token, :activation_token, :reset_token
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
  
  def create_reset_digest
    
    # i believe this User.new_token is on line 38
    self.reset_token = User.new_token
    # this update_attribute seems to be part of Active Record Persistance
    # ActiveRecord::Persistance
    # this lists all the methods:
    # http://api.rubyonrails.org/classes/ActiveRecord/Persistence.html
    # there is a update_attribute and update_attributes
    # User.digest(reset_token)... takes the reset token and then
    # it simply bcrypts it then when the reset token comes back through 
    # it can unlock with it. 
    update_attribute(:reset_digest, User.digest(reset_token))
    # self explanitory
    # this attribute can be accessed like this: 
    # User.all[1].reset_digest - that would access the second user
    # it doesn't work during byebug because its not commiting changes to the
    # database.
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  def send_password_reset_email
    # this UserMailer is found in the 
    # controllers/mailers/user_mailer.rb file
    # self must mean 'the current user'
    # and deliver_now is obvious.
    # how does .deliver_now connect?
    UserMailer.password_reset(self).deliver_now
  end
    
  def password_reset_expired?
    # 2.hours.ago returns:
    # Thu, 25 Feb 2016 03:25:32 UTC +00:00
    reset_sent_at < 2.hours.ago
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
