class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.string :title
      t.text :description
      t.float :price
      t.string :currency

      t.timestamps
    end
  end
end
