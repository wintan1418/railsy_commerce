require "test_helper"

class AdTest < ActiveSupport::TestCase
  test "requires title and placement" do
    ad = Ad.new
    assert_not ad.valid?
    assert_includes ad.errors[:title], "can't be blank"
  end

  test "rejects unknown placement" do
    ad = Ad.new(title: "X", placement: "bogus")
    assert_not ad.valid?
    assert_includes ad.errors[:placement], "is not included in the list"
  end

  test "active scope excludes disabled" do
    assert_includes Ad.active, ads(:home_mid_1)
    assert_not_includes Ad.active, ads(:disabled_ad)
  end

  test "for_placement scope filters correctly" do
    mid = Ad.for_placement("home_mid")
    assert_includes mid, ads(:home_mid_1)
    assert_not_includes mid, ads(:home_bottom)
  end

  test "live scope combines active + current + ordered" do
    live_mid = Ad.live.for_placement("home_mid")
    assert_includes live_mid, ads(:home_mid_1)
    assert_not_includes live_mid, ads(:disabled_ad)
    assert_not_includes Ad.live, ads(:future_ad)
  end
end
