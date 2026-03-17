require "test_helper"

class WishlistTest < ActiveSupport::TestCase
  test "includes_variant?" do
    wishlist = wishlists(:customer_wishlist)
    assert wishlist.includes_variant?(variants(:tshirt_master))
    assert_not wishlist.includes_variant?(variants(:laptop_master))
  end
end
