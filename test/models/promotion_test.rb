require "test_helper"

class PromotionTest < ActiveSupport::TestCase
  test "valid promotion" do
    promo = Promotion.new(name: "Test Promo", promotion_type: :free_shipping)
    assert promo.valid?
  end

  test "requires name" do
    promo = Promotion.new(promotion_type: :free_shipping)
    assert_not promo.valid?
    assert_includes promo.errors[:name], "can't be blank"
  end

  test "requires promotion_type" do
    promo = Promotion.new(name: "Test")
    assert_not promo.valid?
    assert_includes promo.errors[:promotion_type], "can't be blank"
  end

  test "promotion_type enum" do
    promo = promotions(:free_shipping_promo)
    assert promo.free_shipping?
  end

  test "active_promotions scope" do
    active = Promotion.active_promotions
    assert_includes active, promotions(:free_shipping_promo)
    assert_not_includes active, promotions(:inactive_promo)
  end

  test "auto_apply scope" do
    auto = Promotion.auto_apply
    assert_includes auto, promotions(:free_shipping_promo)
    assert_not_includes auto, promotions(:buy_two_get_one)
  end

  test "applicable? for free_shipping" do
    promo = promotions(:free_shipping_promo)
    order = orders(:pending_order)
    assert promo.applicable?(order)
  end

  test "not applicable when inactive" do
    promo = promotions(:inactive_promo)
    order = orders(:pending_order)
    assert_not promo.applicable?(order)
  end
end
