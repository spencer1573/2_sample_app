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
    # you can't just foo: { baz: "something" } it will come up with an error
    # because you don't have curly braces around the whole statement like this
    # something = {foo: { bar: "baz" }
    # so after a significant amount of research all i have found is 
    # post takes in three arguements
    # and this one below takes a string as a path, and a keyvalue pair that i don't 
    # quite understand rails is a little too magical sometimes ... it drives me nuts
    # #QUESTIONUNANSWERED
    post password_resets_path, password_reset: { email: "" }
    # so there is a flash message
    # there for "the flash is empty" is a false statement
    # and assert_not checks that the statement is false
    # there for 
    # assert_not(flash.empty?) => true
    # it took me a second to reason it out.
    assert_not flash.empty?
    # Valid email
    # i don't fully understand it but i'm moving on. 
    post password_resets_path, password_reset: { email: @user.email } 
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    # because i think the flash is present here saying it was sent
    assert_not flash.empty?
    # root takes you right to the / url
    assert_redirected_to root_url
    # PASSWORD RESET FORM
    # for some undetermined reason 
    # :user is all of the sudden equal to @user.
    # no idea why.
    # #QUESTIONUNANSWERED
    user = assigns(:user)
    # WRONG EMAIL
    get edit_password_reset_path(user.reset_token, email: "") 
    assert_redirected_to root_url
    # INACTIVE USER
    # user.activated is returning true currently
    # and is then toggled in the below statement
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # RIGHT EMAIL WRONG TOKEN
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # RIGHT EMAIL, RIGHT TOKEN
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # INVALID PASSWORD & CONFIRMATION 
    # Q: how do i know the difference between post and patch arguments
    # like... which arguements go where?
    # i have no idea why user is taking in password key value pairs
    # #UNANSWERED_QUESTION
    patch password_reset_path(user.reset_token), 
      email: user.email,
      user: { password:              "foobaz",
              password_confirmation: "barquux" }
    assert_select 'div#error_explanation'
    # EMPTY PASSWORD
    patch password_reset_path(user.reset_token), 
      email: user.email,
      user: { password:              "",
              password_confirmation: "" }
    assert_select 'div#error_explanation'
    # VALID PASSWORD & CONFIRMATION
    patch password_reset_path(user.reset_token),
      email: user.email,
      user: { password:              "foobaz",
              password_confirmation: "foobaz" }
    #logged in magically
    assert is_logged_in?
    # showing a flash message
    assert_not flash.empty?
    assert_redirected_to user

  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, password_reset: { email: @user.email }

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
      email: @user.email,
      user: { password:              "foobar",
              password_confirmation: "foobar" }
    assert_response :redirect
    #i'm not sure what this does
    #QUESTIONUNANSWERED
    follow_redirect!
    assert_match /expired/i, response.body

  end

end
