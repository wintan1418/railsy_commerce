require "test_helper"

class ExpireAbandonedCartsJobTest < ActiveJob::TestCase
  test "destroys abandoned carts" do
    cart = Cart.create!
    cart.cart_items.create!(variant: variants(:tshirt_master), quantity: 1)
    Cart.where(id: cart.id).update_all(updated_at: 2.days.ago)

    assert_difference "Cart.count", -1 do
      ExpireAbandonedCartsJob.perform_now
    end
  end

  test "does not destroy recent carts" do
    cart = Cart.create!
    cart.cart_items.create!(variant: variants(:tshirt_master), quantity: 1)

    assert_no_difference "Cart.count" do
      ExpireAbandonedCartsJob.perform_now
    end
  end
end
