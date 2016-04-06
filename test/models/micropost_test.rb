require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    # THIS CODE IS NOT IDIOMATICALLY CORRECT (so why am i writing it?)
    @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    #QUESTION i don't understand why you would set
    #the micropost.user_id to nil, i don't see how that
    #would test the if the id was present
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do 
    @micropost.content = "   "
    assert_not @micropost.valid?
  end


    
end
