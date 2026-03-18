require "test_helper"

class ProductRelationTest < ActiveSupport::TestCase
  test "valid product relation" do
    pr = ProductRelation.new(
      product: products(:tshirt),
      related_product: products(:laptop),
      relation_type: :related
    )
    # Already exists in fixtures, so uniqueness will fail
    pr.related_product = products(:draft_product)
    assert pr.valid?
  end

  test "relation_type enum" do
    pr = product_relations(:tshirt_to_laptop)
    assert pr.related?
  end

  test "uniqueness of related_product scoped to product" do
    pr = ProductRelation.new(
      product: products(:tshirt),
      related_product: products(:laptop),
      relation_type: :cross_sell
    )
    assert_not pr.valid?
    assert_includes pr.errors[:related_product_id], "relation already exists"
  end

  test "belongs to product" do
    pr = product_relations(:tshirt_to_laptop)
    assert_equal products(:tshirt), pr.product
  end

  test "belongs to related_product" do
    pr = product_relations(:tshirt_to_laptop)
    assert_equal products(:laptop), pr.related_product
  end
end
