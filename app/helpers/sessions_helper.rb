module SessionsHelper

  def sign_in(user)
    session[:current_user_id] = [user.id, user.salt]
    self.current_user = user    # is an assignment. 
  end
  
  def current_user=(user)      # Like a ruby setter perhaps?
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_session_id    # ||= or equals
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    session[:current_user_id] = nil
    self.current_user = nil
  end
    
  def current_user?(user)
    user ==  current_user
  end
  
  def deny_access
    # Flash message is passed as an options hash to the redirect_to function
    store_location
    redirect_to signin_path, :notice => "Please signin to access this page."
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  private
  
    def user_from_session_id
      User.authenticate_with_salt(*session_id)     # * to allow a method that is expecting more than one variable on accept an array
    end
    
    def session_id
      session[:current_user_id] || [nil, nil]
    end

    def store_location
      session[:return_to] = request.fullpath
    end
    
    def clear_return_to
      session[:return_to] = nil
    end

end
