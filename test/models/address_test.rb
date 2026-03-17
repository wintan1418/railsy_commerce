require "test_helper"

class AddressTest < ActiveSupport::TestCase
  test "valid address" do
    addr = addresses(:customer_shipping)
    assert addr.valid?
  end

  test "requires required fields" do
    addr = Address.new
    assert_not addr.valid?
    assert_includes addr.errors[:first_name], "can't be blank"
    assert_includes addr.errors[:last_name], "can't be blank"
    assert_includes addr.errors[:address_line_1], "can't be blank"
    assert_includes addr.errors[:city], "can't be blank"
    assert_includes addr.errors[:postal_code], "can't be blank"
  end

  test "full_name" do
    addr = addresses(:customer_shipping)
    assert_equal "Jane Doe", addr.full_name
  end

  test "one_line" do
    addr = addresses(:customer_shipping)
    assert_includes addr.one_line, "123 Main St"
    assert_includes addr.one_line, "New York"
  end
end
