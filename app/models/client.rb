class Client < ApplicationRecord
  has_many :invoices

  validates :name, presence: true, length: { minimum: 3 }
  validates :code, length: { maximum: 6 }

  before_save :ensure_code

  private 

  def ensure_code
    self.code = name.first(3) if code.blank?

    code.upcase!
  end
end
