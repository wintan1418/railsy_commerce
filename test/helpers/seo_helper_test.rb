require "test_helper"

class SeoHelperTest < ActionView::TestCase
  include SeoHelper

  test "product_json_ld generates structured data" do
    product = products(:tshirt)
    json_ld = product_json_ld(product)

    assert_includes json_ld.to_s, '"@type":"Product"'
    assert_includes json_ld.to_s, product.name
  end
end
