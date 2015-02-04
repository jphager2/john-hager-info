class Invoice < ActiveRecord::Base
  has_many :service_items, dependent: :destroy
  has_many :expense_items, dependent: :destroy

  accepts_nested_attributes_for :service_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :expense_items, reject_if: :all_blank, allow_destroy: true

  validates :client_id, presence: true
  validates :date, presence: true
  validates :period_covered_from, presence: true
  validates :period_covered_to, presence: true

  validate :unique_number

  before_save :ensure_due_date
  before_save :dont_save_if_published

  def published?
    self.published
  end

  private
  def dont_save_if_published
    self.freeze if published?
  end

  def ensure_due_date
    self.due_date = (self.date + 30) unless self.due_date
  end

  def ensure_invoice_year
    self.invoice_year = self.date.year unless self.invoice_year
  end

  def ensure_invoice_count
    unless self.invoice_count
      client_invoices = Invoice
        .where(invoice_year: self.invoice_year).order(:invoice_count)
        .where.not(client_id: self.client_id, id: self.id)
      last_invoice = client_invoices.last
      self.invoice_count = last_invoice.try(:invoice_count).to_i + 1
    end
  end

  def set_client_code
    self.client_code = Client.find(self.client_id).code
  end

  def set_client_number
    set_client_code; ensure_invoice_year; ensure_invoice_count
    self.number = "#{self.client_code}-#{self.invoice_year}-" +
      "#{self.invoice_count.to_s.rjust(3, '0')}"
  end

  def unique_number
    set_client_number
    unique = Invoice.where(number: self.number)
      .where.not(id: self.id).empty?
    unless unique
      errors[:invoice_count] = "This number is already taken!"
    end
  end
end
