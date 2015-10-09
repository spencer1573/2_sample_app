require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
 
  def setup
    # if you are tracing where michael 
    # is located it is in the /test/fixtures/users.yml
    # i believe... i could be wrong.
    @user = users(:michael)
  end
  
  test "login with valid information followed by logout" do 
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user # checks right "redirect target"
    follow_redirect! # actually visit targeted page
    assert_template 'users/show' # asserts show.html.erb
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url #home? 
    # this simulates if we were logging out in a second window
    # like if we had two windows up.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,         count: 0
    assert_select "a[href=?]", user_path(@user),    count: 0
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
  
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end
  
  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
  
end
