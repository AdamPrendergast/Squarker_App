module SessionsHelper

  def sign_in(user)
    session[:current_user_id] = [user.id, user.salt]
    self.current_user = user    # is an assignment. 
  end
  
  def current_user=(user)      # Like a ruby setter perhaps?
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token    # ||= or equals
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    session[:current_user_id] = nil
    self.current_user = nil
  end
  
  private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)     # * to allow a method that is expecting more than one variable on accept an array
    end
    
    def session_id
      session[:current_user_id] || [nil, nil]
    end

end