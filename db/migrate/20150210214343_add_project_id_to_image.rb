class AddProjectIdToImage < ActiveRecord::Migration
  def change
    add_column :images, :product_id, :integer
  end
end
