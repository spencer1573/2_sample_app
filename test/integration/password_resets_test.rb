require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # "called before every single test"
  # -http://guides.rubyonrails.org/testing.html
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    # so i run rake routes... 
    # it brings up a list of the routes
    # so all you do is add a _path or
    # i think _url and then that 
    # will always return the correct url
    # this is so freakin awesome.
    get new_password_reset_path
    # so after researching this it sounds like
    # what it is.. it isn't just asserting
    # a url... its asserting a template
    # from the views folder
    assert_template 'password_resets/new'
    # TESTING FOR INVALID EMAIL
    # so using post here instead of get
    # is important because we are trying to 
    # create a resource (even though we don't)
    # and i get that we are putting an email in 
    # but i wouldn't come up with that method on my own
    # the password_reset: i have no idea what this is 
    # refering to.
    post password_resets_path, password_reset: { email: "" }
  
  end



end
