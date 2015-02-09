require 'faraday'
class OnedriveController < AdminController
  skip_before_action :authenticate_user

  def login
    auth = Skydrive::Oauth::Client.new(ENV["ONEDRIVE_CLIENT_ID"], ENV["ONEDRIVE_CLIENT_SECRET"], "http://www.john-hager.info/onedrive", "wl.skydrive_update,wl.offline_access")
    redirect_to auth.authorize_url 
  end

  def create
    if params[:code].present?
      @access_token = @client.get_access_token(params[:code])
      session[:access_token] = @access_token
    elsif params[:refresh_token].present?
      30.times { puts "=*" * 30 } 
    end
  end
end
