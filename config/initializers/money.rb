MoneyRails.configure do |config|
  config.default_currency = :usd
  config.rounding_mode = BigDecimal::ROUND_HALF_UP

  # Register additional currencies if needed
  # Money supports ISO 4217 currencies out of the box:
  # USD, EUR, GBP, JPY, CAD, AUD, etc.

  # Allow no_cents_if_whole for cleaner display
  config.no_cents_if_whole = false
end
