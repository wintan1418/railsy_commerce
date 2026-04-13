require "test_helper"

class BannerTest < ActiveSupport::TestCase
  test "requires a title" do
    banner = Banner.new
    assert_not banner.valid?
    assert_includes banner.errors[:title], "can't be blank"
  end

  test "valid with title only" do
    assert Banner.new(title: "Hello").valid?
  end

  test "active scope excludes disabled banners" do
    assert_includes Banner.active, banners(:spring_sale)
    assert_not_includes Banner.active, banners(:disabled_banner)
  end

  test "ordered scope respects position" do
    ordered = Banner.ordered.to_a
    positions = ordered.map(&:position)
    assert_equal positions.sort, positions
  end

  test "current scope includes always-on banners" do
    assert_includes Banner.current, banners(:spring_sale)
  end

  test "current scope excludes future-scheduled banners" do
    assert_not_includes Banner.current, banners(:future_banner)
  end

  test "current scope excludes expired banners" do
    expired = Banner.create!(title: "Expired", ends_at: 1.day.ago)
    assert_not_includes Banner.current, expired
  end

  test "live scope combines active + current + ordered" do
    live = Banner.live
    assert_includes live, banners(:spring_sale)
    assert_includes live, banners(:new_arrivals)
    assert_not_includes live, banners(:disabled_banner)
    assert_not_includes live, banners(:future_banner)
  end
end
