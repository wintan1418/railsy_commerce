require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "valid product" do
    product = Product.new(name: "Test Product", category: categories(:clothing))
    assert product.valid?
    assert_equal "test-product", product.slug
    assert_equal "draft", product.status
  end

  test "requires name" do
    product = Product.new
    assert_not product.valid?
    assert_includes product.errors[:name], "can't be blank"
  end

  test "status enum" do
    assert products(:tshirt).active?
    assert products(:draft_product).draft?
  end

  test "master_variant" do
    tshirt = products(:tshirt)
    assert_equal variants(:tshirt_master), tshirt.master_variant
  end

  test "price delegates to master variant" do
    tshirt = products(:tshirt)
    assert_equal Money.new(2999, "USD"), tshirt.price
  end

  test "has option types through product_option_types" do
    tshirt = products(:tshirt)
    assert_includes tshirt.option_types, option_types(:size)
    assert_includes tshirt.option_types, option_types(:color)
  end

  test "in_stock? checks variants" do
    tshirt = products(:tshirt)
    assert tshirt.in_stock?
  end

  test "by_category scope" do
    clothing = categories(:clothing)
    products = Product.by_category(clothing.id)
    assert_includes products, products(:tshirt)
    assert_not_includes products, products(:laptop)
  end

  test "search by name" do
    results = Product.search("T-Shirt")
    assert_includes results, products(:tshirt)
    assert_not_includes results, products(:laptop)
  end
end
