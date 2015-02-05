class Client < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }
  validates :code, length: { maximum: 6 }

  before_save :ensure_code

  private 
  def ensure_code
    self.code = self.name.first(3) unless self.code.present?
    self.code.upcase!
  end
end