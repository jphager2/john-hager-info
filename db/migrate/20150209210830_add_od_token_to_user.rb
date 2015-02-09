class AddOdTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :od_token, :text
  end
end
