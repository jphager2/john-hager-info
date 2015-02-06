require 'addressable/uri'
class OnedriveController < AdminController
  def login
  end

  def create
    if params[:code].present?
      parameters = {
        "CLIENT_ID" => ENV["ONEDRIVE_CLIENT_ID"],
        "REDIRECT_URI" => "http://www.john-hager.info/onedrive",
        "CLIENT_SECRET" => ENV["ONEDRIVE_CLIENT_SECRET"],
        "AUTHORIZATION_CODE" => params[:code],
      }
      curl('https://login.live.com/oauth20_token.srf',parameters,:post)
    end
  end

  private 
  def curl(path, parameters, method)
    encoded_params = Addressable::URI.new.query_values(parameters).query
    path = "#{path}?#{encoded_params}"
    `curl #{path} -X #{method.to_s.upcase} -H "Content-Type: application/x-www-form-urlencoded"`
  end
end
