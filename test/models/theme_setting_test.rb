require "test_helper"

class ThemeSettingTest < ActiveSupport::TestCase
  test "requires key" do
    setting = ThemeSetting.new(label: "Test", group: "general", setting_type: "text")
    assert_not setting.valid?
    assert_includes setting.errors[:key], "can't be blank"
  end

  test "requires label" do
    setting = ThemeSetting.new(key: "test_key", group: "general", setting_type: "text")
    assert_not setting.valid?
    assert_includes setting.errors[:label], "can't be blank"
  end

  test "requires group" do
    setting = ThemeSetting.new(key: "test_key", label: "Test", group: "", setting_type: "text")
    assert_not setting.valid?
  end

  test "validates group inclusion" do
    setting = ThemeSetting.new(key: "test_key", label: "Test", group: "invalid", setting_type: "text")
    assert_not setting.valid?
    assert_includes setting.errors[:group], "is not included in the list"
  end

  test "validates setting_type inclusion" do
    setting = ThemeSetting.new(key: "test_key", label: "Test", group: "general", setting_type: "invalid")
    assert_not setting.valid?
    assert_includes setting.errors[:setting_type], "is not included in the list"
  end

  test "requires unique key" do
    setting = ThemeSetting.new(key: "primary_color", label: "Dupe", group: "colors", setting_type: "color")
    assert_not setting.valid?
    assert_includes setting.errors[:key], "has already been taken"
  end

  test "get returns stored value" do
    assert_equal "#c9a96e", ThemeSetting.get("primary_color")
  end

  test "get returns default when not found" do
    assert_equal "fallback", ThemeSetting.get("nonexistent", "fallback")
  end

  test "get returns nil when not found and no default" do
    assert_nil ThemeSetting.get("nonexistent")
  end

  test "set updates existing value" do
    ThemeSetting.set("primary_color", "#ff0000")
    assert_equal "#ff0000", ThemeSetting.get("primary_color")
  end

  test "by_group scope returns settings for group" do
    colors = ThemeSetting.by_group("colors")
    assert colors.all? { |s| s.group == "colors" }
  end

  test "boolean? returns true for boolean settings" do
    setting = theme_settings(:announcement_enabled)
    assert setting.boolean?
  end

  test "color? returns true for color settings" do
    setting = theme_settings(:primary_color)
    assert setting.color?
  end
end
