module ApplicationHelper
  def format_price(amount_cents, currency = nil)
    currency ||= StoreConfig.store_currency
    Money.new(amount_cents, currency).format
  end
end
