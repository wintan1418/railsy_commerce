require "test_helper"

module Promotions
  class ApplyPromotionsServiceTest < ActiveSupport::TestCase
    test "applies free shipping promotion" do
      order = orders(:pending_order)
      original_shipping = order.shipping_total_cents

      # Ensure promo is applicable
      promo = promotions(:free_shipping_promo)
      assert promo.applicable?(order)

      result = ApplyPromotionsService.call(order: order)
      assert result.success?
      assert_equal true, result.payload[:applied]
      assert_equal 0, order.reload.shipping_total_cents
    end

    test "returns success with applied false when no promotions apply" do
      # Make all promotions inactive
      Promotion.update_all(active: false)

      order = orders(:pending_order)
      result = ApplyPromotionsService.call(order: order)
      assert result.success?
      assert_equal false, result.payload[:applied]
    end
  end
end
