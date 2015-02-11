class ImageSize < ActiveRecord::Base
  belongs_to :image

  def url
    self.source
  end

  def self.create_from_object(object, image_id)
    size = object["images"].find {|i| i["type"] == self.od_type}
    if size 
      self.create(
        image_id: image_id, height: size["height"],  
        width: size["width"], source: size["source"]
      )
    end
  end

  def update_from_object(object)
    self.update(source: object["source"])
  end

  def self.od_type
    ''
  end
end
