class PasswordResetsController < ApplicationController
  def new
  end

  def create
    #i'm not exactly sure why email needs to be downcased.
    @user = User.find_by(email: params[:password_reset][:email].downcase)
  
    if @user
      # i looked ahead this gets built in the user model later
      @user.create_reset_digest
    
  end

  def edit
  end
end
