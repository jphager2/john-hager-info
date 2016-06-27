class Project < ActiveRecord::Base

  scope :by_updated, -> { order(updated_at: :desc) }

  def image
    name.underscore.parameterize.underscore + ".jpg"
  end
end
