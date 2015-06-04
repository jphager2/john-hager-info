class OnedriveClientController < AdminController

  private
  def set_client
    if @client = current_user.od_client
      begin 
        # replace with the smallest request
        @client.my_skydrive 
        return @client
      rescue Skydrive::Error => e
        flash[:notice] = "Token Expired" if e.code == "http_error_401" 
      end
    else
      flash[:notice] = "Login to Onedrive Failed"
    end
    redirect_to onedrive_login_path
  end
end
