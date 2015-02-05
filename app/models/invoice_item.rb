class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice

  def human_name
    self.class.to_s.sub(/Item/, '').pluralize
  end
end
