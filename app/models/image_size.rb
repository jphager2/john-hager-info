class ImageSize < ActiveRecord::Base
  belongs_to :image

  def url
    self.source
  end

  def self.create_from_object(object, image_id)
    size = object["images"].find {|i| i["type"] == self.od_type}
    if size 
      self.create(
        image_id: image_id, height: normal["height"],  
        width: normal["width"], source: normal["source"]
      )
    end
  end

  def self.od_type
    ''
  end
end
