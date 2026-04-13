require "test_helper"

module Account
  class DigitalDownloadsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:customer)
      products(:tshirt).update!(is_digital: true)
      @order = orders(:pending_order)
      @order.update!(user: users(:customer))
      @item = @order.order_items.first
      @download = DigitalDownload.create!(order_item: @item)
    end

    test "index lists user's downloads" do
      get account_digital_downloads_url
      assert_response :success
      assert_match products(:tshirt).name, response.body
    end

    test "show redirects to file or back with alert when no files" do
      get account_digital_download_url(@download)
      # No digital files attached in fixtures → alert + redirect back
      assert_redirected_to account_digital_downloads_url
      assert_match(/No file available/, flash[:alert])
    end

    test "show rejects download for another user's purchase" do
      sign_in_as users(:admin)  # different user
      get account_digital_download_url(@download)
      assert_redirected_to account_digital_downloads_url
    end

  end
end
