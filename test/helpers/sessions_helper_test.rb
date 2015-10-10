# this is NOT a gem it is a file found in this directory
# it is located here:
# test/test_helper.rb
require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  
  # "provides a setup method that you can override
  # to define logic that runs before each test"
  # -http://chriskottom.com/blog/2014/10/4-fantastic-ways-to-set-up-state-in-minitest/ 
  # i'm guessing this is true about the testing
  # system that is put in place here.
  def setup
    @user = users(:michael)
    # i'm not sure which remember this is refering to
    # i'm going to keep going and see if i find out. if i took a guess though
    # i would say that its in
    # app/controllers/helpers/sessions_helper.rb
    remember(@user)
  end
  
  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end
  
  test "current_user returns nil when remember digest is wrong" do
    ### => see explanaitons and work out logic here when you come back
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end