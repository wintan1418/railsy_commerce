require "test_helper"

module Admin
  class PagesControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists pages" do
      get admin_pages_url
      assert_response :success
    end

    test "show page" do
      get admin_page_url(pages(:about_us))
      assert_response :success
    end

    test "new page form" do
      get new_admin_page_url
      assert_response :success
    end

    test "create page" do
      assert_difference "Page.count" do
        post admin_pages_url, params: {
          page: { title: "Privacy Policy", body: "Our privacy policy content.", published: true }
        }
      end
      assert_redirected_to admin_page_url(Page.last)
    end

    test "edit page form" do
      get edit_admin_page_url(pages(:about_us))
      assert_response :success
    end

    test "update page" do
      page = pages(:about_us)
      patch admin_page_url(page), params: {
        page: { title: "About Our Company" }
      }
      assert_redirected_to admin_page_url(page)
      assert_equal "About Our Company", page.reload.title
    end

    test "destroy page" do
      assert_difference "Page.count", -1 do
        delete admin_page_url(pages(:about_us))
      end
      assert_redirected_to admin_pages_url
    end
  end
end
