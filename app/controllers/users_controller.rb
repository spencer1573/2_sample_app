class UsersController < ApplicationController
  # i think i understand this
  # the before_action refers to doing the
  # 'logged_in_user' method and then 
  # only 
  # can this user access
  # edit and update
  # without the only restriction, the before_action
  # applies to every method in the UsersController
  # not sure about the private methods
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    #debugger
  end

  
  def new
    @user = User.new
  end
  
  def create
    
    @user = User.new(user_params)
    # if save method is successful it returns true
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
    # rails automatically infers this means
    # redirect_to user_url(@user)
      redirect_to @user 
    else
      render 'new'
    end
    
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    #update_attributes returns true or false
    # depending on whether or not it was successful
    # in updating attributes
    # user_params goes into update attributes to stop
    # mass assignment vulnerability
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        # this is about the flash hash:
        # http://api.rubyonrails.org/classes/ActionDispatch/Flash/FlashHash.html
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    

end
