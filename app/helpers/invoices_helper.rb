module InvoicesHelper

  def address_for(client)
    content_tag(:p) do 
      [
        client.name,
        client.address1, 
        client.address2, 
        city_state_zip_line(client),
        client.country,
        client.registration_no,
        client.tax_no
      ]
        .select {|attr| !attr.blank? }.each do |line|
          concat line
          concat '<br>'.html_safe
        end
    end
  end

  def city_state_zip_line(client)
    [:city,:state,:zip].map { |atrb| 
      if client.__send__(atrb).present?
        content_tag :span, client.__send__(atrb) 
      end
    }.compact.join(', ').html_safe
  end
end
