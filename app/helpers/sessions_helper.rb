module SessionsHelper
  
  #this is going to be used in other places
  # "logs in the given user"
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def current_user?(user)
    user == current_user
  end
  
  
  #this makes it so you don't have to look up the
  # the user all the time. its the sort of thing you need
  # to implement in your noko_convert
  # 'Returns the current logged-in user (if any)'.

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
      # just taking apart current user to make sure i understand
      # what was written
    elsif (user_id = cookies.signed[:user_id])
      #raise   # this raise is here to see if the test still pass when it is
      # run and that the raise doesn't happen.
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
    
  end


  def logged_in?
    !current_user.nil?
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # redirects either to stored location or to default 
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  # store the url trying to get accessed
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
  
  
end
