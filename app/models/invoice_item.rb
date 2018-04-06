class InvoiceItem < ApplicationRecord
  belongs_to :invoice

  before_validation :ensure_currency
  before_validation :ensure_price

  validates :title, presence: true

  def human_name
    self.class.to_s.sub(/Item/, '').pluralize
  end

  private

  def ensure_currency
    self.currency = Invoice::Currencies.first if currency.blank?
  end

  def ensure_price
    self.price ||= 0
  end
end
