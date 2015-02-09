require 'faraday'
class OnedriveController < AdminController
  skip_before_action :authenticate_user
  skip_before_action :set_client

  def login
    redirect_to @auth.authorize_url 
  end

  def create
    if params[:code].present?
      @access_token = @auth.get_access_token(params[:code])
      session[:access_token] = @access_token
    elsif params[:refresh_token].present?
      30.times { puts "=*" * 30 } 
    end
  end

  private
  def set_auth
    @auth = Skydrive::Oauth::Client.new(ENV["ONEDRIVE_CLIENT_ID"], ENV["ONEDRIVE_CLIENT_SECRET"], "http://www.john-hager.info/onedrive", "wl.skydrive_update,wl.offline_access")
  end
end
