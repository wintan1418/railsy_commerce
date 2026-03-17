module Tax
  class CalculateTaxService < ApplicationService
    def initialize(order:)
      @order = order
    end

    def call
      address = @order.shipping_address
      return success(tax_cents: 0) unless address

      tax_rate = TaxRate.for_address(address)
      return success(tax_cents: 0) unless tax_rate

      taxable = @order.subtotal_cents - @order.discount_total_cents
      tax_cents = tax_rate.calculate_tax(taxable)

      @order.update!(tax_total_cents: tax_cents)
      @order.recalculate_totals!

      success(tax_cents: tax_cents, rate: tax_rate)
    end
  end
end
