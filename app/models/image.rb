require 'addressable/uri'
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

  def size_url(name, client)
    uri = Addressable::URI.new
    uri.query_values = { 
      type: name.to_s, 
      url: od_item(client).object["link"] 
    }
    "https://apis.live.net/v5.0/skydrive/get_item_preview?#{uri.query}"
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
      image.update(
        normal_url:    size_url(:normal, client),
        album_url:     size_url(:album, client),
        small_url:     size_url(:small, client),
        thumbnail_url: size_url(:thumbnail, client)
      )
      NormalSize.create_from_object(object, image.id)
      AlbumSize.create_from_object(object, image.id)
      ThumbnailSize.create_from_object(object, image.id)
      FullSize.create_from_object(object, image.id)
    end
    image
  end

  def od_item(client)
    client.get_skydrive_object_by_id(od_id)
  end

  def update_data(client)
    # update the data in the image with current data on skydrive
    item = client.get_skydrive_object_by_id(od_id)
    return false unless item
    object = item.object
    self.update(
      name: object["name"], 
      description: object["description"],
      normal_url:    size_url(:normal, client),
      album_url:     size_url(:album, client),
      small_url:     size_url(:small, client),
      thumbnail_url: size_url(:thumbnail, client)
    )
    self.normal.update_from_object(object)
    self.album.update_from_object(object)
    self.thumbnail.update_from_object(object)
    self.full.update_from_object(object)
  end

  def self.update_all_data(client)
    Image.all.each { |image| image.update_data(client) }
  end
end
