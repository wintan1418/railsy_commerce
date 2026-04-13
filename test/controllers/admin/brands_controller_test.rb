require "test_helper"

module Admin
  class BrandsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists brands" do
      get admin_brands_url
      assert_response :success
    end

    test "new brand form" do
      get new_admin_brand_url
      assert_response :success
    end

    test "create brand" do
      assert_difference "Brand.count" do
        post admin_brands_url, params: {
          brand: { name: "New Brand", active: true, featured: false }
        }
      end
      assert_redirected_to admin_brands_url
    end

    test "create with invalid data re-renders" do
      assert_no_difference "Brand.count" do
        post admin_brands_url, params: { brand: { name: "" } }
      end
      assert_response :unprocessable_entity
    end

    test "update brand" do
      patch admin_brand_url(brands(:sony)), params: {
        brand: { description: "Updated" }
      }
      assert_redirected_to admin_brands_url
      assert_equal "Updated", brands(:sony).reload.description
    end

    test "toggle_featured flips featured flag" do
      brand = brands(:sony)
      assert brand.featured?
      post toggle_featured_admin_brand_url(brand)
      assert_not brand.reload.featured?
    end

    test "destroy brand unlinks products" do
      sony = brands(:sony)
      products(:tshirt).update!(brand: sony)
      assert_difference "Brand.count", -1 do
        delete admin_brand_url(sony)
      end
      assert_nil products(:tshirt).reload.brand_id
    end

    test "non-admin cannot access" do
      sign_in_as users(:customer)
      get admin_brands_url
      assert_response :redirect
    end
  end
end
