require 'faraday'
class OnedriveController < AdminController
  skip_before_action :authenticate_user
  def login
  end

  def create
    if params[:code].present?
      args = {
        "CLIENT_ID" => ENV["ONEDRIVE_CLIENT_ID"],
        "REDIRECT_URI" => "http://www.john-hager.info/onedrive",
        "CLIENT_SECRET" => ENV["ONEDRIVE_CLIENT_SECRET"],
        "AUTHORIZATION_CODE" => params[:code],
      }
      puts 'Posting to Onedrive'
      post('https://login.live.com/', 'oauth20_token.srf', args)
      puts 'Post Done!'
    else
      params.each do |k,v|
        puts "#{k}:\t#{v}"
      end
    end
  end

  private 
  def post(host, path, args)
    conn = Faraday.new(url: host)  do |f|
      f.request :url_encoded
      f.adapter Faraday.default_adapter
    end
    conn.post(path, args) do |req|
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
    end
  end
end
