require "test_helper"

class GiftCardTest < ActiveSupport::TestCase
  test "generates code on create if blank" do
    gc = GiftCard.create!(initial_balance_cents: 1000)
    assert gc.code.present?
    assert_match(/\AGC-/, gc.code)
  end

  test "sets balance to initial when not provided" do
    gc = GiftCard.create!(initial_balance_cents: 2500)
    assert_equal 2500, gc.balance_cents
  end

  test "available? reflects active + not expired + not depleted" do
    assert gift_cards(:active_50).available?
    assert_not gift_cards(:expired_card).available?
    assert_not gift_cards(:depleted_card).available?
    assert_not gift_cards(:disabled_card).available?
  end

  test "usable_amount_cents caps at balance or total" do
    gc = gift_cards(:partially_used) # balance 4000
    assert_equal 4000, gc.usable_amount_cents(10000)
    assert_equal 3000, gc.usable_amount_cents(3000)
  end

  test "usable_amount_cents is 0 when unavailable" do
    assert_equal 0, gift_cards(:expired_card).usable_amount_cents(10000)
    assert_equal 0, gift_cards(:depleted_card).usable_amount_cents(10000)
  end

  test "redeem! deducts balance and records transaction" do
    gc = gift_cards(:active_50)
    order = orders(:pending_order)
    gc.redeem!(2000, order: order)
    assert_equal 3000, gc.reload.balance_cents
    tx = gc.gift_card_transactions.last
    assert_equal 2000, tx.amount_cents
    assert_equal "redeem", tx.kind
    assert_equal order, tx.order
  end

  test "redeem! raises when amount exceeds balance" do
    gc = gift_cards(:partially_used)
    assert_raises(ArgumentError) { gc.redeem!(99_999, order: orders(:pending_order)) }
  end
end
