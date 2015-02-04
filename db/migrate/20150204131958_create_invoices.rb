class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :number
      t.integer :invoice_year
      t.integer :invoice_count
      t.date :date
      t.date :due_date
      t.date :period_covered_from
      t.date :period_covered_to
      t.float :price
      t.integer :client_id
      t.string :client_code

      t.timestamps
    end
  end
end
