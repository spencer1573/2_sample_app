require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    # THIS CODE IS NOT IDIOMATICALLY CORRECT (so why am i writing it?)
    @micropost = Micropost.new(content: "Lorem ipsum", user
end
