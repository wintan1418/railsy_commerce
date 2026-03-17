require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "get login page" do
    get new_session_url
    assert_response :success
  end

  test "sign in with valid credentials" do
    user = users(:customer)
    post session_url, params: { email_address: user.email_address, password: "password" }
    assert_redirected_to root_url
  end

  test "sign in with invalid credentials" do
    post session_url, params: { email_address: "wrong@example.com", password: "wrong" }
    assert_redirected_to new_session_url
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "sign out" do
    sign_in_as users(:customer)
    delete session_url
    assert_redirected_to new_session_url
  end
end
