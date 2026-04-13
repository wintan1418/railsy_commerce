require "test_helper"

module Admin
  class GiftCardsControllerTest < ActionDispatch::IntegrationTest
    setup { sign_in_as users(:admin) }

    test "index lists gift cards" do
      get admin_gift_cards_url
      assert_response :success
    end

    test "new form" do
      get new_admin_gift_card_url
      assert_response :success
    end

    test "issue gift card generates code" do
      assert_difference "GiftCard.count" do
        post admin_gift_cards_url, params: {
          gift_card: { initial_balance_cents: 10000, active: true }
        }
      end
      gc = GiftCard.last
      assert_redirected_to admin_gift_card_path(gc)
      assert gc.code.start_with?("GC-")
      assert_equal 10000, gc.balance_cents
    end

    test "show displays transactions" do
      get admin_gift_card_url(gift_cards(:active_50))
      assert_response :success
    end

    test "destroy removes card" do
      assert_difference "GiftCard.count", -1 do
        delete admin_gift_card_url(gift_cards(:depleted_card))
      end
    end

    test "non-admin blocked" do
      sign_in_as users(:customer)
      get admin_gift_cards_url
      assert_response :redirect
    end
  end
end
