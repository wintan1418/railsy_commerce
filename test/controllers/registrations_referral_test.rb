require "test_helper"

class RegistrationsReferralTest < ActionDispatch::IntegrationTest
  test "captures ref code from URL and links new user" do
    referrer = users(:customer)

    get new_registration_url(ref: referrer.referral_code)
    assert_response :success

    post registration_url, params: {
      user: {
        email_address: "newbie@example.com",
        password: "password123",
        password_confirmation: "password123",
        first_name: "New",
        last_name: "Bie",
        role: "customer"
      }
    }

    user = User.find_by(email_address: "newbie@example.com")
    assert user.present?
    assert_equal referrer.id, user.referred_by_id
  end

  test "ignores bogus ref code" do
    get new_registration_url(ref: "BOGUS9999")
    post registration_url, params: {
      user: {
        email_address: "noref@example.com",
        password: "password123",
        password_confirmation: "password123",
        first_name: "No",
        last_name: "Ref",
        role: "customer"
      }
    }
    user = User.find_by(email_address: "noref@example.com")
    assert_nil user.referred_by_id
  end
end
