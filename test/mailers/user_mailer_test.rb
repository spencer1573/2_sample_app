require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  # to test everything in this just do this rake test
	# rake test TEST=test/mailers/user_mailer_test.rb

  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    # this account_activation method is found in 
    # app/controllers/mailers/user_mailer.rb
    mail = UserMailer.account_activation(user)
    # assert_equal assertions count as one
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    # assert_match count as two assertions for some reason
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
    
  end
	

  

	test "password_reset" do 
		# users(:#{fixture name}) is how you access
		# the fixtures... found in test/fixtures/users.yml
		user = users(:michael)
  end
end
