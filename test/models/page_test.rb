require "test_helper"

class PageTest < ActiveSupport::TestCase
  test "valid page" do
    page = Page.new(title: "Test Page", body: "Some content")
    assert page.valid?
    assert_equal "test-page", page.slug
  end

  test "requires title" do
    page = Page.new
    assert_not page.valid?
    assert_includes page.errors[:title], "can't be blank"
  end

  test "slug must be unique" do
    existing = pages(:about_us)
    page = Page.new(title: "Different", slug: existing.slug)
    assert_not page.valid?
    assert_includes page.errors[:slug], "has already been taken"
  end

  test "published scope" do
    published = Page.published
    assert_includes published, pages(:about_us)
    assert_not_includes published, pages(:unpublished_page)
  end

  test "ordered scope" do
    ordered = Page.ordered
    assert_equal pages(:about_us), ordered.first
  end

  test "friendly_id generates slug from title" do
    page = Page.create!(title: "Shipping Policy", body: "Our shipping policy...")
    assert_equal "shipping-policy", page.slug
  end
end
