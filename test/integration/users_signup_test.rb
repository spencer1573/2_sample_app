require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    # this seems pretty self explanitory
    ActionMailer::Base.deliveries.clear
  end
  
  
  test "invalid signup information" do
    # remember this isn't necessary it just helps for
    # readability and sometimes errors, talking about
    # get signup_path
    get signup_path
  
    assert_no_difference 'User.count' do 
    
      post users_path, user: { name: "",
                              email: "user@invalid",
                              password:               "foo",
                              password_confirmation:  "bar" }
    
    end
  
    assert_template 'users/new'
    #take these asserts apart next time
    # so looking at the source leads me to believe
    # that of course div is the tag and error_explanation is
    # the id as notified by the # (pound sign)
    assert_select 'div#error_explanation'
    # the period denotes class i'm guessing just going of the source
    # and that class is field_with_errors
    assert_select 'div.field_with_errors'
  end
  
  test "valid signup information with account activation" do 
    get signup_path
    assert_difference 'User.count', 1 do 
      post_via_redirect users_path, user: { name: "Example User",
                                            email: "user@example.com", 
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    # this assigns is a special test method... its not in the model or anything
    user = assigns(:user)
    assert_not user.activated?
    # this attempts to log in before activaiton
    log_in_as(user)
    assert_not is_logged_in?
    # it is avalid token but its for the wrong user
    # (email as identifier possibly)
    get edit_account_activation_path('invalid token')
    assert_not is_logged_in?
    # valid token wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    # this apparently doesn't happen automatically
    follow_redirect!
  end
end
