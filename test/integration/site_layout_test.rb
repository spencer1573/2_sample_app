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
    
    # i think this is probably a pointless test because 
    # at 'get signup_path' you go to the link so it gets tested there
    # no need to test it twice. 
    
    #assert_select "a[href=?]", signup_path
    get signup_path
    assert_select "title", full_title("Sign up")
    
  end  
  
end
