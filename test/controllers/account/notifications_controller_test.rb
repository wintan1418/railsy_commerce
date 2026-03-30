require "test_helper"

module Account
  class NotificationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:customer)
    end

    test "index shows notifications" do
      get account_notifications_url
      assert_response :success
      assert_select "h1", /Notifications/
    end

    test "mark_read marks notification as read" do
      notification = notifications(:unread_notification)
      assert_nil notification.read_at

      post mark_read_account_notification_url(notification)
      assert_redirected_to account_notifications_url

      notification.reload
      assert_not_nil notification.read_at
    end

    test "mark_all_read marks all as read" do
      assert users(:customer).notifications.unread.any?

      post mark_all_read_account_notifications_url
      assert_redirected_to account_notifications_url

      assert_equal 0, users(:customer).notifications.unread.count
    end

    test "requires authentication" do
      delete session_url
      get account_notifications_url
      assert_redirected_to new_session_url
    end
  end
end
