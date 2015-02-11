class AdminController < ApplicationController
  layout 'admin'
  skip_before_action :load_github_events

  around_action :log_exceptions
  before_action :authenticate_user
  before_action :set_auth
  before_action :set_client#, if: Proc.new { Rails.env == 'Production' }

  private
  def authenticate_user
    redirect_to root_path unless signed_in?
  end

  def set_client
    if @client = current_user.od_client 
      begin 
        @client.my_skydrive # replace with the smallest request
        return @client
      rescue Skydrive::Error => e
        flash[:notice] = "Token Expired" if e.code == "http_error_401" 
      end
    else
      flash[:notice] = "Login to Onedrive Failed"
    end
    redirect_to onedrive_login_path
  end

  def set_auth
    @auth = Skydrive::Oauth::Client.new(ENV["ONEDRIVE_CLIENT_ID"], ENV["ONEDRIVE_CLIENT_SECRET"], "http://www.john-hager.info/onedrive", "wl.skydrive_update,wl.offline_access")
  end

  def log_exceptions
    yield
  rescue Object => e
    puts "\n" * 3
    puts 'Error Caught in Admin Controller'
    puts e, e.message
    puts "\n" * 3
    raise
  end
end
