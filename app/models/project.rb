class Project < ActiveRecord::Base

  def image
    self.name.downcase.gsub(/[-\s]/, '_') + '.png'
  end
end
