require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  
  #setup is special because it is run before every test.
  def setup
    @base_title = "Ruby on Rails Tut Samle App"
  end
  
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end
  
end
