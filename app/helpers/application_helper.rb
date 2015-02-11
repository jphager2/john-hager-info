require 'base64'

module ApplicationHelper
  def base64(url)
    Base64.encode64(open(url).read)
  end

  def base64_image_tag(data_type, url, options = {})
    options[:src] = "data:#{data_type};base64,#{base64(url)}"
    content_tag :image, nil, options 
  end
end
