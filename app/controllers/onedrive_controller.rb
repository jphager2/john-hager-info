require 'faraday'
class OnedriveController < AdminController
  skip_before_action :authenticate_user, only: :create
  skip_before_action :set_client

  def login
    redirect_to @auth.authorize_url 
  end

  def create
    if params[:code].present?
      @access_token = @auth.get_access_token(params[:code])
      if @access_token
        current_user.update(od_token: @access_token.token)
        flash[:notice] = "Successfully logged in"
      end
      redirect_to root_path
    end
  end
end
