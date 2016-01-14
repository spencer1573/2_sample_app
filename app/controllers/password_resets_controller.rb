class PasswordResetsController < ApplicationController
  def new
  end

  def create
    #i'm not exactly sure why email needs to be downcased.
    @user = User.find_by(email: params[:password_reset][:email].downcase)
  
    if @user
      # i looked ahead this gets built in the user model later
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      # i believe this pulls up the 
      # new in 'app/views/password_resets/new.html.erb'
      render 'new'
    end
    
  end

  def edit
  end
end
