class AdminController < ApplicationController
  layout 'admin'
  skip_before_action :load_github_events

  before_action :authenticate_user
  before_action :set_client

  private
  def authenticate_user
    redirect_to root_path unless signed_in?
  end

  def set_client
    if session[:access_token] 
      @client = Skydrive::Oauth::Client(session[:access_token])
    else
      @client = Skydrive::Oauth::Client.new(ENV["ONEDRIVE_CLIENT_ID"], ENV["ONEDRIVE_CLIENT_SECRET"], "http://www.john-hager.info/onedrive", "wl.skydrive_update,wl.offline_access")
    end
  end

end
