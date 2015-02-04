class AddTypeColumnToInvoiceItem < ActiveRecord::Migration
  def change
    add_column :invoice_items, :type, :string
  end
end
