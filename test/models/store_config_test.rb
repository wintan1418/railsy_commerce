require "test_helper"

class StoreConfigTest < ActiveSupport::TestCase
  test "get returns stored value" do
    assert_equal "RailsyCommerce", StoreConfig.get("store_name")
  end

  test "get returns default when not found" do
    assert_equal "fallback", StoreConfig.get("nonexistent", "fallback")
  end

  test "set creates or updates" do
    StoreConfig.set("test_key", "test_value")
    assert_equal "test_value", StoreConfig.get("test_key")

    StoreConfig.set("test_key", "updated")
    assert_equal "updated", StoreConfig.get("test_key")
  end

  test "store_name helper" do
    assert_equal "RailsyCommerce", StoreConfig.store_name
  end

  test "requires unique key" do
    config = StoreConfig.new(key: "store_name", value: "dupe")
    assert_not config.valid?
  end
end
