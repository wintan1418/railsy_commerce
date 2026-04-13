require "test_helper"

class DigitalDownloadTest < ActiveSupport::TestCase
  setup do
    @product = products(:tshirt)
    @product.update!(is_digital: true)
    @order = orders(:pending_order)
    @item = @order.order_items.first
  end

  test "generates access token on create" do
    dd = DigitalDownload.create!(order_item: @item)
    assert dd.access_token.present?
    assert_operator dd.access_token.length, :>, 20
  end

  test "record_download increments count and stamps time" do
    dd = DigitalDownload.create!(order_item: @item)
    assert_equal 0, dd.download_count
    dd.record_download!
    assert_equal 1, dd.download_count
    assert dd.last_downloaded_at.present?
  end

  test "expired returns true when expires_at in past" do
    dd = DigitalDownload.create!(order_item: @item, expires_at: 1.day.ago)
    assert dd.expired?
    assert_not dd.available?
  end

  test "not expired when expires_at blank" do
    dd = DigitalDownload.create!(order_item: @item)
    assert_not dd.expired?
    assert dd.available?
  end
end
