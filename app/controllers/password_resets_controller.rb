class PasswordResetsController < ApplicationController
  before_action :get_user,    only: [:edit, :update]
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
      # this was verified by breaking the new.html.erb in that folder
      # its routed to initially here:
      # <%= link_to "(forgot password)", new_password_reset_path %>
      # i'm guessing that they aren't really interchangable because
      # they do different things.
      render 'new'
    end
    
  end

  def edit
  end
end
