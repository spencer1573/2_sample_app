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


end
