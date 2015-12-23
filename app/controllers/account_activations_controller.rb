class AccountActivationsController < ApplicationController
  def edit 
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])  
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      # this is put in place incase an activation link
      # ends up in the wrong hands
      # so it just links to the root_url
      flash[:danger] = "Invalid activation link"
      redirect_to root_url 
    end
  end
end
