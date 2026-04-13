require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home renders with live banners" do
    get root_url
    assert_response :success
    assert_select "[data-slideshow-target='slide']", minimum: 1
  end

  test "show published page" do
    get page_url(slug: pages(:about_us).slug)
    assert_response :success
  end

  test "404 for unpublished page" do
    get page_url(slug: pages(:unpublished_page).slug)
    assert_response :not_found
  end

  test "404 for non-existent page" do
    get page_url(slug: "non-existent-page")
    assert_response :not_found
  end
end
