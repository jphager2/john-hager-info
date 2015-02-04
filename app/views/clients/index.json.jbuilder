json.array!(@clients) do |client|
  json.extract! client, :id, :name, :code, :contact_name, :contact_email, :contact_phone
  json.url client_url(client, format: :json)
end
