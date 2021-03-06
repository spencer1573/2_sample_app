class PasswordResetsController < ApplicationController
  # so i think this means that before you do the edit or update
  # methods, you need to do get_user and valid user first
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
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
  
  def update
    
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      # i used to have this as 
      # render edit
      # not 
      # render 'edit'
      # it was causing some problems
      render 'edit'
      # that is defined in private (user_params)
    elsif @user.update_attributes(user_params)
      # this is found in helpers/sessions_helper.rb
      # all it does is this
      # session[:user_id] = user.id
      # where it takes in a user argument
      # so the question is what does this do to the 
      # params when the session is changed
      log_in @user 
      flash[:success] = "Password has been reset."
      # i'm guessing that this @user has /user/1 somewhere
      # in it but i'm not sure... i'll need to look it up tomorrow
      redirect_to @user
    else
      # i believe that this is located in 
      # app/views/password_resets/edit
      # it just renders that view i'm pretty sure
      render 'edit'
    end

  end

      
  private

    def user_params
      # i will need to investigate what .require(:user) does tommorrow
      params.require(:user).permit(:password, :password_confirmation)
    end

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

    # checks if the reset token is too old
    def check_expiration
      # this password_reset_expired... is in the
      # user model
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
