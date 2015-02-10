class CreateImageSizes < ActiveRecord::Migration
  def change
    create_table :image_sizes do |t|
      t.integer :image_id
      t.integer :height
      t.integer :width
      t.string :source
      t.string :type

      t.timestamps
    end
  end
end
