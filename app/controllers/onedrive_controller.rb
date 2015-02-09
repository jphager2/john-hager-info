require 'faraday'
class OnedriveController < AdminController
  skip_before_action :authenticate_user

  def login
    redirect_to @client.authorize_url 
  end

  def create
    if params[:code].present?
      @access_token = @client.get_access_token(params[:code])
      session[:access_token] = @access_token
    end
  end
end
