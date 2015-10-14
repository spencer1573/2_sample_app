class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    #debugger
  end

  
  def new
    @user = User.new
  end
  
  def create
    
    @user = User.new(user_params) # not the final implementation!
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
      # enter code to eventually handle successful update
    else
      render 'edit'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

end
