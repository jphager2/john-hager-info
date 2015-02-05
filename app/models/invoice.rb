class Invoice < ActiveRecord::Base
  Currencies = %w( CZK USD EUR )
  has_many :service_items, dependent: :destroy
  has_many :expense_items, dependent: :destroy

  accepts_nested_attributes_for :service_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :expense_items, reject_if: :all_blank, allow_destroy: true

  before_validation :set_number

  validates :client_id, presence: true
  validates :date, presence: true
  validates :period_covered_from, presence: true
  validates :period_covered_to, presence: true
  validates :number, uniqueness: true

  before_save :ensure_due_date
  before_save :ensure_currency
  before_save :total_price

  after_save :freeze_if_published

  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where.not(published: true) }

  def initialize(attributes = {})
    super
    freeze_if_published if self.persisted?
  end

  def published?
    self.published
  end

  private
  def convert_currency(amount, from, to)
    rates = { eur_usd: 1.14, eur_czk: 27.78, eur_eur: 1, usd_eur: 0.88, usd_czk: 24.31, usd_usd: 1, czk_eur: 0.036, czk_usd: 0.041, czk_czk: 1 }
    amount * rates["#{from}_#{to}".downcase.to_sym]
  end

  def total_price
    sum = (self.service_items + self.expense_items).inject(0) { |s,item|
      s + convert_currency(item.price, item.currency, self.currency)
    }
    self.price = sum
  end
  
  def freeze_if_published
    self.freeze if self.published?
  end

  def ensure_due_date
    self.due_date = (self.date + 30) unless self.due_date
  end

  def ensure_currency
    self.currency ||= Currencies.first
  end

  def ensure_invoice_year
    self.invoice_year = self.date.year unless self.invoice_year
  end

  def ensure_invoice_count
    unless self.invoice_count
      client_invoices = Invoice
        .where(invoice_year: self.invoice_year).where.not(id: self.id)
        .where(client_id: self.client_id).order(:invoice_count)
      last_invoice = client_invoices.last
      self.invoice_count = last_invoice.try(:invoice_count).to_i + 1
    end
  end

  def set_client_code
    self.client_code = Client.find(self.client_id).code
  end

  def set_number
    set_client_code; ensure_invoice_year; ensure_invoice_count
    self.number = "#{self.client_code}-#{self.invoice_year}-" +
      "#{self.invoice_count.to_s.rjust(3, '0')}"
  end
end