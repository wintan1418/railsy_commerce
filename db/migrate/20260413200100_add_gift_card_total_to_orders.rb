class AddGiftCardTotalToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :gift_card_total_cents, :integer, default: 0, null: false
    add_reference :orders, :gift_card, foreign_key: true
  end
end
