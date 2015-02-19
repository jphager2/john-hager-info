class AddCreditNoteToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :credit_note, :boolean
    Invoice.update_all(credit_note: false)
    change_column_default :invoices, :credit_note, false
  end
end
