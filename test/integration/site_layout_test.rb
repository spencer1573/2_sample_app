require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", about_path
    # for some reason this works now and it wasn't before. 
    # i don't know what i did differently.
    assert_select "a[href=?]", signup_path
    #puts 
    get signup_path
    assert_select "title", "Sign up | Ruby on Rails Tut Sample App"
  end  
  
end
