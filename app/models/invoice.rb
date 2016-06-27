class Invoice < ActiveRecord::Base

  Currencies = %w( CZK USD EUR )

  has_many :service_items, dependent: :destroy
  has_many :expense_items, dependent: :destroy

  belongs_to :client

  accepts_nested_attributes_for :service_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :expense_items, reject_if: :all_blank, allow_destroy: true

  before_validation :set_number!

  validates :client_id, presence: true
  validates :date, presence: true
  validates :period_covered_from, presence: true
  validates :period_covered_to, presence: true
  validates :number, uniqueness: true

  validate :credit_note_price_not_positive

  before_save :ensure_due_date!
  before_save :ensure_currency!

  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where.not(published: true) }
  scope :by_date, -> { order(date: :desc) }

  def in_currency(cur)
    convert_currency(self.price, self.currency, cur)
  end

  def save
    readonly! if was_published?
    super
  end

  private

  def was_published?
    published_was
  end

  def credit_note_price_not_positive
    total_price!
    if credit_note? && price > 0
      error = 'Credit Notes Should not have a Positive Price!'
      errors.add(:base, error)
    end
  end

  def convert_currency(amount, from, to)
    rates = { eur_usd: 1.14, eur_czk: 27.78, eur_eur: 1, usd_eur: 0.88, usd_czk: 24.31, usd_usd: 1, czk_eur: 0.036, czk_usd: 0.041, czk_czk: 1 }
    amount * rates["#{from}_#{to}".downcase.to_sym]
  end

  def total_price!
    sum = (service_items + expense_items).inject(0) { |s, item|
      s + convert_currency(item.price, item.currency, currency)
    }
    self.price = sum
  end

  def ensure_due_date!
    if due_date.blank?
      self.due_date = date + (credit_note? ? 0 : 30)
    end
  end

  def ensure_currency!
    self.currency = Currencies.first if currency.blank?
  end

  def ensure_invoice_year!
    self.invoice_year = date.year if date.present? && invoice_year.blank?
  end

  def ensure_invoice_count!
    return if invoice_count.present? || errors.any?

    last_invoice_count = Invoice
      .where(invoice_year: invoice_year)
      .where(client_id: client_id)
      .where.not(id: id)
      .order(:invoice_count)
      .pluck(:invoice_count)
      .last

    self.invoice_count = last_invoice_count.to_i + 1
  end

  def set_client_code!
    self.client_code = client.code
  end

  def set_number!
    set_client_code!  
    ensure_invoice_year! 
    ensure_invoice_count!

    count = invoice_count.to_s.rjust(3, '0')
    num = "#{client_code}-#{invoice_year}-#{count}"
    num = num.prepend('CN-') if credit_note?

    self.number = num
  end
end
