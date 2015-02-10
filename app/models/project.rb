class Project < ActiveRecord::Base
  has_one :image

  validates :image_id, presence: true
end
