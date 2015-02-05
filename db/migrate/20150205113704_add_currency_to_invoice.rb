class AddCurrencyToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :currency, :string
  end
end
