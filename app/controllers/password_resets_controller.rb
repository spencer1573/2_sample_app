class PasswordResetsController < ApplicationController
  # so i think this means that before you do the edit or update
  # methods, you need to do get_user and valid user first
  before_action :get_user,    only: [:edit, :update]
  before_action :valid_user,  only: [:edit, :update]
  
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
  
  private

    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    #so i'm not exactly sure how params[:id] returns
    # the reset token but i guess its somewhere in there
    # id love to explore that with byebug when i get this
    # up and running on the imac. 
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

end
