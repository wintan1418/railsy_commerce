require "test_helper"

module Admin
  class FlashSalesControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists flash sales" do
      get admin_flash_sales_url
      assert_response :success
    end

    test "new flash sale form" do
      get new_admin_flash_sale_url
      assert_response :success
    end

    test "create flash sale" do
      assert_difference "FlashSale.count" do
        post admin_flash_sales_url, params: {
          flash_sale: {
            name: "Lightning Deal",
            starts_at: 1.hour.from_now,
            ends_at: 1.day.from_now,
            discount_percentage: 25,
            active: true
          }
        }
      end
      assert_redirected_to admin_flash_sales_url
    end

    test "create with invalid data re-renders form" do
      assert_no_difference "FlashSale.count" do
        post admin_flash_sales_url, params: {
          flash_sale: { name: "", starts_at: Time.current, ends_at: 1.hour.ago }
        }
      end
      assert_response :unprocessable_entity
    end

    test "update assigns products" do
      sale = flash_sales(:upcoming_sale)
      patch admin_flash_sale_url(sale), params: {
        flash_sale: {
          name: sale.name,
          starts_at: sale.starts_at,
          ends_at: sale.ends_at,
          discount_percentage: sale.discount_percentage,
          product_ids: [ products(:tshirt).id, products(:laptop).id ]
        }
      }
      assert_redirected_to admin_flash_sales_url
      assert_equal 2, sale.reload.products.count
    end

    test "toggle flash sale active state" do
      sale = flash_sales(:running_sale)
      assert sale.active?
      post toggle_admin_flash_sale_url(sale)
      assert_not sale.reload.active?
    end

    test "destroy flash sale" do
      assert_difference "FlashSale.count", -1 do
        delete admin_flash_sale_url(flash_sales(:ended_sale))
      end
    end

    test "non-admin cannot access" do
      sign_in_as users(:customer)
      get admin_flash_sales_url
      assert_response :redirect
    end
  end
end
