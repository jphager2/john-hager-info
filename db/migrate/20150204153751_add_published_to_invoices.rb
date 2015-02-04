class AddPublishedToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :published, :boolean
  end
end
