require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(
      email_address: "test@example.com",
      password: "password",
      first_name: "Test",
      last_name: "User"
    )
    assert user.valid?
    assert_equal "customer", user.role
  end

  test "requires email" do
    user = User.new(password: "password", first_name: "Test", last_name: "User")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "requires unique email" do
    existing = users(:customer)
    user = User.new(
      email_address: existing.email_address,
      password: "password",
      first_name: "Test",
      last_name: "User"
    )
    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "requires first_name and last_name" do
    user = User.new(email_address: "test@example.com", password: "password")
    assert_not user.valid?
    assert_includes user.errors[:first_name], "can't be blank"
    assert_includes user.errors[:last_name], "can't be blank"
  end

  test "normalizes email" do
    user = User.new(email_address: "  TEST@Example.COM  ")
    assert_equal "test@example.com", user.email_address
  end

  test "full_name" do
    user = users(:customer)
    assert_equal "Jane Doe", user.full_name
  end

  test "role enum" do
    admin = users(:admin)
    customer = users(:customer)
    assert admin.admin?
    assert customer.customer?
  end
end
