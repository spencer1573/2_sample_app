class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #log the user in and redirect to the user's show page.
      log_in user
      remember user
      redirect_to user #this is ~> user_url(user) <~
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination' #not quite right!
      render 'new'
      
    end
  end
  
  # found a problem, it said 'destory' so it wasn't working
  def destroy
    log_out
    redirect_to root_url
  end
  
end
