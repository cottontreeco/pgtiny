module SessionsHelper

  # sign the user into session, at this point
  # user password should have been authenticated
  def sign_in(user)
    #generate a new token every time a user signs in
    remember_token = User.new_remember_token
    #store is in cookies for 20 years
    cookies.permanent[:remember_token] = remember_token
    #encrypt it then save it with the user data
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    #remembers the user
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by_remember_token(remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    # reset token to avoid "stolen token"
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    # remove the token from this session
    cookies.delete(:remember_token)
    # set the user to nil in case we will use sign out without redirect
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
end
