require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
 
  def setup
    @user = users(:michael)
  end
  
  test "login with valid information" do 
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to @user # checks right "redirect target"
    follow_redirect! # actually visit targeted page
    assert_template 'users/show' # asserts show.html.erb
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?, "the flash is displaying on the second page"
  end
  
end
