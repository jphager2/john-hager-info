class AddSizeUrlsToImage < ActiveRecord::Migration
  def change
    add_column :images, :normal_url, :text
    add_column :images, :album_url, :text
    add_column :images, :small_url, :text
    add_column :images, :thumbnail_url, :text
  end
end
