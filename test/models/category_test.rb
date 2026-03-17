require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "valid category" do
    category = Category.new(name: "New Category")
    assert category.valid?
    assert_equal "new-category", category.slug
  end

  test "requires name" do
    category = Category.new
    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
  end

  test "parent-child relationship" do
    clothing = categories(:clothing)
    shirts = categories(:shirts)
    assert_equal clothing, shirts.parent
    assert_includes clothing.children, shirts
  end

  test "active scope" do
    active = Category.active
    assert_includes active, categories(:clothing)
    assert_not_includes active, categories(:inactive_category)
  end

  test "roots scope" do
    roots = Category.roots
    assert_includes roots, categories(:clothing)
    assert_not_includes roots, categories(:shirts)
  end

  test "has many products" do
    clothing = categories(:clothing)
    assert_includes clothing.products, products(:tshirt)
  end
end
