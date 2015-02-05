class SessionsController < ApplicationController
  def new
    load_github_activity
    redirect_to root_path if signed_in?
    @user = User.new
  end
  
  def create
    @user = User.find_by(email: user_params[:email].downcase)

    if @user
      @user = @user.authenticate(user_params[:password])

      if @user
        sign_in @user
        redirect_to root_path
      else
        flash.now[:message] = "invalid email/password combination" 
        render 'new'
      end
    else
      flash.now[:message] = "User was not found."
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
