require "test_helper"

class UserReferralTest < ActiveSupport::TestCase
  test "generates referral_code on create" do
    user = User.create!(
      email_address: "newref@example.com",
      password: "password123",
      first_name: "New",
      last_name: "Ref",
      role: "customer"
    )
    assert user.referral_code.present?
    assert_equal 8, user.referral_code.length
  end

  test "referral_code is unique" do
    User.create!(email_address: "one@example.com", password: "password123", first_name: "A", last_name: "B", role: "customer")
    user2 = User.new(email_address: "two@example.com", password: "password123", first_name: "C", last_name: "D", role: "customer")
    user2.save!
    assert_not_equal User.first.referral_code, user2.referral_code
  end

  test "can be linked to a referrer" do
    referrer = users(:admin)
    u = User.create!(
      email_address: "referred@example.com",
      password: "password123",
      first_name: "X", last_name: "Y", role: "customer",
      referred_by: referrer
    )
    assert_equal referrer, u.referred_by
    assert_includes referrer.referrals_received, u
  end
end
