class UsersController < ApplicationController
  def login 
  end

  def auth
  end 

  def create
    redirect_to root_path unless signed_in?

    if params.include?(:email)
      user = User.new
      user.name, user.email = params[:name], params[:email]
      user.password = params[:password]
      user.password_confirmation = params[:password_confirmation]
      
      if user.save
        redirect_to controller: :pages, action: :index
      else
        flash[:messages] = user.errors.full_messages
        redirect_to action: :create
      end
    else
      @user = User.new
    end
  end

  def destroy
    redirect_to root_path unless signed_in?

    user = User.find(params[:id])
    user.destroy

    redirect_to controller: :pages, action: :admin
  end
end
