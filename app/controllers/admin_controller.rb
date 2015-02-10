class AdminController < ApplicationController
  layout 'admin'
  skip_before_action :load_github_events

  around_action :log_exceptions
  before_action :authenticate_user
  before_action :set_auth
  before_action :set_client, if: Proc.new { Rails.env == 'Production' }

  private
  def authenticate_user
    redirect_to root_path unless signed_in?
  end

  def set_client
    puts 'SETTING CLIENT'
    if current_user.od_token
      access_token = @auth
        .get_access_token_from_hash(current_user.od_token)
      @client = Skydrive::Client.new(access_token)
    else
      flash[:notice] = "Login to Onedrive Failed"
      redirect_to root_path
    end
  end

  def set_auth
    puts 'SETTING AUTH'
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
