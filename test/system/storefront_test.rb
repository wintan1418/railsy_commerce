require "application_system_test_case"

class StorefrontTest < ApplicationSystemTestCase
  test "visiting the home page" do
    visit root_url
    assert_selector "h1", minimum: 1
  end

  test "browsing products" do
    visit products_url
    assert_selector "h1"
  end

  test "viewing a product" do
    product = products(:tshirt)
    visit product_url(product)
    assert_text product.name
  end
end
