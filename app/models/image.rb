class Image < ActiveRecord::Base
  ALBUM_PATH = 'folder.d1d76abfa84f5934.D1D76ABFA84F5934!135'
  
  DATA_TYPES = { "jpeg" => 'data/jpeg', "jpg" => 'data/jpeg', "png" => 'data/png' }

  has_one :normal_size
  has_one :album_size
  has_one :thumbnail_size
  has_one :full_size

  def data_type
    DATA_TYPES[self.name.slice(/(\.(\w+))?$/, 2).downcase]
  end

  def normal
    self.normal_size
  end

  def album
    self.album_size
  end

  def thumbnail
    self.thumbnail_size
  end

  def full
    self.full_size
  end

  def self.upload(client, file, filename = file.try(:original_filename))
    created = client.upload(ALBUM_PATH, URI::encode(filename), file)
    return false unless created
    item = client.get_skydrive_object_by_id(ALBUM_PATH).files.items
      .find { |item| item.object["name"] == filename } 
    object = item.object
    image = Image.create(od_id: object["id"], name: object["name"])
    if image
      NormalSize.create_from_object(object, image.id)
      AlbumSize.create_from_object(object, image.id)
      ThumbnailSize.create_from_object(object, image.id)
      FullSize.create_from_object(object, image.id)
    end
    image
  end

  def update_data(client)
    # update the data in the image with current data on skydrive
  end
end
