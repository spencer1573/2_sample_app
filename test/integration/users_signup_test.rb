require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "invalid signup information" do
    # remember this isn't necessary it just helps for
    # readability and sometimes errors, talking about
    # get signup_path
    get signup_path
  
    assert_no_difference 'User.count' do 
    
      post users_path, user: { name: "",
                              email: "user@invalid",
                              password:               "foo",
                              password_confirmation:  "bar" 
      }
    
    end
    assert_template 'users/new'
  end

end
