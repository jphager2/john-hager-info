class AddAddressFieldsToClient < ActiveRecord::Migration
  def change
    add_column :clients, :address1, :string
    add_column :clients, :address2, :string
    add_column :clients, :city, :string
    add_column :clients, :state, :string
    add_column :clients, :zip, :string
    add_column :clients, :country, :string
  end
end
