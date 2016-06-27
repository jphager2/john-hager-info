class RemoveImages < ActiveRecord::Migration
  def change
    drop_table :images
  end
end
