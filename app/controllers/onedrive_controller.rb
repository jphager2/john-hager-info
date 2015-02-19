class OnedriveController < AdminController
  skip_before_action :authenticate_user, only: :create

  before_action :set_auth

  def new 
    redirect_to @auth.authorize_url 
  end

  def create
    if params[:code].present?
      @access_token = @auth.get_access_token(params[:code])
      if @access_token
        current_user.update_attribute(:od_token, @access_token.token)
        flash[:notice] = "Successfully logged in"
      else 
        puts "FAILED TO GET ACCESS TOKEN!!!"
      end
      redirect_to root_path
    end
  end

  private
  def set_auth
    @auth = Skydrive::Oauth::Client.new(ENV["ONEDRIVE_CLIENT_ID"], ENV["ONEDRIVE_CLIENT_SECRET"], "http://www.john-hager.info/onedrive", "wl.skydrive_update,wl.offline_access")
  end
end
