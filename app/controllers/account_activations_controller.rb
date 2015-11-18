class AccountActivationsController < ApplicationController
  def edit 
    user = User.find_by(email: params[:email])
    user.update_attribute(:activated,     true)
    user.update_attribute(:activated_at,  Time.zone.now)
    
    
    
end
