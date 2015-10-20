require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:michael)
  end
  
  test "index including pagination" do
    log_in_as(@user)
    # this users path comes from rescources i believe
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      # so this is saying there should be an html link, called by each
      # user name that is linked to their user profile.
      assert_select 'a[href=?]', user_path(user), text: user.name
    end

  end
  
  
end
