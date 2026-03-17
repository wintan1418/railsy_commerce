require "test_helper"

module Admin
  class CategoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists categories" do
      get admin_categories_url
      assert_response :success
    end

    test "create category" do
      assert_difference "Category.count", 1 do
        post admin_categories_url, params: {
          category: { name: "New Category", active: true }
        }
      end
      assert_redirected_to admin_categories_url
    end

    test "update category" do
      patch admin_category_url(categories(:clothing)), params: {
        category: { name: "Updated Clothing" }
      }
      assert_redirected_to admin_categories_url
      assert_equal "Updated Clothing", categories(:clothing).reload.name
    end

    test "delete category" do
      assert_difference "Category.count", -1 do
        delete admin_category_url(categories(:inactive_category))
      end
      assert_redirected_to admin_categories_url
    end
  end
end
