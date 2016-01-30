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
	
	# to test just the password_reset
	# rake test TEST=test/mailers/user_mailer_test.rb TESTOPTS="--name password_reset" 

	test "password_reset" do 
		# users(:#{fixture name}) is how you access
		# the fixtures... found in test/fixtures/users.yml
		user = users(:michael)
		# User.new_token appears to come from line 38 of the user model
 		# reset_token starts on line 5 of the user model, and it is 
		# setter is being assigned a new random url safe 22 character
		# base 64 string.
		user.reset_token = User.new_token
		# this password_reset is found in the
		# in app/mailers/usermailer.rb, i don't believe 
		# the mail actually delievers it just sends
		mail = UserMailer.password_reset(user)
		# found out about .method(:#{the_method}).source_location
		# found out about .method(:#{the_method}).owner
 		# learned that subject is owned by 
		# "ActionMailer::MessageDelivery" 
		# hopefully i can learn where subject is defined first in 
		# in the MessageDelivery class/model.
		# in the new 5.0 version of rails it could be defining 
		# mail.subject on line 549 of 
		# https://github.com/rails/rails/blob/master/actionmailer/lib/action_mailer/base.rb
		assert_equal "Password reset", mail.subject



  end
end
