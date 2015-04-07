class AddTaxNumbersToClient < ActiveRecord::Migration
  def change
    add_column :clients, :registration_no, :string
    add_column :clients, :tax_no, :string
  end
end
