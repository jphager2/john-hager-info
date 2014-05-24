class UsersController < ApplicationController
  def new
  end

  def login 
  end

  def auth
  end 

  def create
    if signed_in?
      user = User.new
      user.name, user.email = params[:name], params[:email]
      user.password = params[:password]
      user.password_confirmation = params[:password_confirmation]
      
      if user.save
        redirect_to controller: :pages, action: :index
      else
        flash[:messages] = user.errors.full_messages
        redirect_to action: :signup
      end
    else
      redirect_to controller: :pages, action: :admin
    end
  end

  def destroy
    if signed_in?
      user = User.find(params[:id])
      user.destroy
    end

    redirect_to controller: :pages, action: :admin
  end
end
