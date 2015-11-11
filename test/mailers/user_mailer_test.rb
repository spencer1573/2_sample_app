require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    # this account_activation method is found in 
    # app/controllers/mailers/user_mailer.rb
    mail = UserMailer.account_activation(user)
    byebug
   # assert_equal "Account activation", mail.subject
   # assert_equal [user.email], mail.to
  #  assert_equal ["noreply@example.com"]
    
  end

end
