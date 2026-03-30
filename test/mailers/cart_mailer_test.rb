require "test_helper"

class CartMailerTest < ActionMailer::TestCase
  test "abandoned email" do
    cart = carts(:customer_cart)
    email = CartMailer.abandoned(cart)

    assert_equal "You left items in your cart!", email.subject
    assert_equal [ cart.user.email_address ], email.to
    assert_match "Complete Your Purchase", email.body.encoded
  end

  test "abandoned email not sent without user" do
    cart = carts(:guest_cart)
    email = CartMailer.abandoned(cart)
    assert_nil email.to
  end
end
