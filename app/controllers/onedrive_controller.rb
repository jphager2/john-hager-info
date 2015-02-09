require 'faraday'
class OnedriveController < AdminController
  skip_before_action :authenticate_user
  before_action :set_client

  def login
    redirect_to @client.authorize_url 
  end

  def create
    if params[:code].present?
      @access_token = @client.get_access_token(params[:code])
      puts '+=' * 50
      puts @access_token
      puts @client.to_s
      puts '+=' * 50
    end
  end

  private 
  def set_client
    @client = Skydrive::Oauth::Client.new(ENV["ONEDRIVE_CLIENT_ID"], ENV["ONEDRIVE_CLIENT_SECRET"], "http://www.john-hager.info/onedrive", "wl.skydrive_update,wl.offline_access")
  end
end
