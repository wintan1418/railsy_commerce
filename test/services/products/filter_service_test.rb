require "test_helper"

class Products::FilterServiceTest < ActiveSupport::TestCase
  test "returns all active products with no filters" do
    result = Products::FilterService.call(params: {})
    assert result.success?
    assert_includes result.payload[:products], products(:tshirt)
    assert_not_includes result.payload[:products], products(:draft_product)
  end

  test "filters by category" do
    result = Products::FilterService.call(params: { category_id: categories(:clothing).id })
    assert result.success?
    assert_includes result.payload[:products], products(:tshirt)
  end

  test "filters by search" do
    result = Products::FilterService.call(params: { q: "T-Shirt" })
    assert result.success?
    assert_includes result.payload[:products], products(:tshirt)
    assert_not_includes result.payload[:products], products(:laptop)
  end

  test "sorts by newest" do
    result = Products::FilterService.call(params: { sort: "newest" })
    assert result.success?
    assert result.payload[:products].count >= 2
  end
end
