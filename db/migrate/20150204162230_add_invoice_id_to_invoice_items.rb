class AddInvoiceIdToInvoiceItems < ActiveRecord::Migration
  def change
    add_column :invoice_items, :invoice_id, :integer
  end
end
