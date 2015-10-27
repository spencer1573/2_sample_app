require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
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
    # login_url refers to the get login route in routes.rb
    # to access '/users/1/edit' you would type
    # edit_user_path(1) instead of login_url
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect edit when logged in as wrong user" do 
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty? # for some reason the flash is empty and i'm not sure why
    assert_redirected_to root_url
  end
  
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect index when not logged in" do 
    # this index refers to the users controller method.
    get :index
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    # it looks like these assert no differences have to 
    # evaluate a block to work, you can even put in an error
    # message after the expression ('User.count') and then the block
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  
  end

end
