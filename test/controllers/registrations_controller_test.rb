require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "get registration page" do
    get new_registration_url
    assert_response :success
  end

  test "create account with valid data" do
    assert_difference "User.count", 1 do
      post registration_url, params: {
        user: {
          email_address: "new@example.com",
          password: "password",
          password_confirmation: "password",
          first_name: "New",
          last_name: "User"
        }
      }
    end
    assert_redirected_to root_url
    assert_equal "customer", User.last.role
  end

  test "create account with invalid data" do
    assert_no_difference "User.count" do
      post registration_url, params: {
        user: {
          email_address: "",
          password: "password",
          password_confirmation: "password",
          first_name: "",
          last_name: ""
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "create account with mismatched passwords" do
    assert_no_difference "User.count" do
      post registration_url, params: {
        user: {
          email_address: "new@example.com",
          password: "password",
          password_confirmation: "different",
          first_name: "New",
          last_name: "User"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
