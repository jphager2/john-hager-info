json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :number, :invoice_year, :invoice_count, :date, :due_date, :period_covered_from, :period_covered_to, :price, :customer_id, :customer_code
  json.url invoice_url(invoice, format: :json)
end
