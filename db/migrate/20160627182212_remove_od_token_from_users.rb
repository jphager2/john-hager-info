class RemoveOdTokenFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :od_token
  end
end
