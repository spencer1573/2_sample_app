module SessionsHelper
  
  #this is going to be used in other places
  # "logs in the given user"
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #this makes it so you don't have to look up the
  # the user all the time. its the sort of thing you need
  # to implement in your noko_convert
  # 'Returns the current logged-in user (if any)'.
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
end
