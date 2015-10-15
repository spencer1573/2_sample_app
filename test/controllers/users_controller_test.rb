require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:michael)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    # i'm pretty sure that this does exactly the same thing
    #      ~> process :edit, "GET", id: @user <~
    # but for readability:
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  
  
 # test "should redirect update when not"


end
