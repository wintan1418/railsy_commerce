require "test_helper"

class BrandTest < ActiveSupport::TestCase
  test "requires a name" do
    brand = Brand.new
    assert_not brand.valid?
    assert_includes brand.errors[:name], "can't be blank"
  end

  test "slug auto-generates from name" do
    brand = Brand.create!(name: "Super Brand")
    assert_equal "super-brand", brand.slug
  end

  test "active scope excludes disabled" do
    assert_includes Brand.active, brands(:sony)
    assert_not_includes Brand.active, brands(:disabled_brand)
  end

  test "featured scope returns featured brands" do
    assert_includes Brand.featured, brands(:sony)
    assert_includes Brand.featured, brands(:apple)
    assert_not_includes Brand.featured, brands(:disabled_brand)
  end

  test "products_count counts only active products" do
    sony = brands(:sony)
    products(:tshirt).update!(brand: sony)
    products(:laptop).update!(brand: sony)
    products(:draft_product).update!(brand: sony)
    assert_equal 2, sony.products_count
  end
end
