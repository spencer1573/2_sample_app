class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #log the user in and redirect to the user's show page.
      
    else
      # Create an error message.
      flash[:danger] = 'Invalid email/password combination' #not quite right!
      render 'new'
      
    end
  end

  def destory
  end

end
