class SessionsController < ApplicationController
  def create
    load_github_activity
    if params.include?(:email)
      @user = User.find_by(email: params[:email].downcase)

      if @user
        @user = @user.authenticate(params[:password])

        if @user
          sign_in @user
          redirect_to root_path
        else
          flash.now[:message] = "invalid email/password combination" 
          render 'create'
        end
      else
        flash.now[:message] = "User was not found."
        render 'create'
      end
    else
      @user = User.new
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
