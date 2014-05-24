module SessionsHelper
  # Sets the cookie for user's session
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  # Changes the current_user's remember_token so the cookie can't be 
  # stollen and used to login
  # Then it deletes the cookie and clears the current_user
  def sign_out
    current_user.update_attribute(:remember_token, 
                          User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  # Gets current_user for views and controllers
  # This allows for users to remain signed in between pages until
  # the cookie is destroyed (by timeout or user logout)
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end
end
