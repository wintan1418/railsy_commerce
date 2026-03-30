require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  test "valid notification" do
    notification = Notification.new(
      user: users(:customer),
      title: "Test notification",
      notification_type: "info"
    )
    assert notification.valid?
  end

  test "requires title" do
    notification = Notification.new(
      user: users(:customer),
      notification_type: "info"
    )
    assert_not notification.valid?
    assert notification.errors[:title].any?
  end

  test "requires notification_type" do
    notification = Notification.new(
      user: users(:customer),
      title: "Test"
    )
    notification.notification_type = nil
    assert_not notification.valid?
  end

  test "validates notification_type inclusion" do
    notification = Notification.new(
      user: users(:customer),
      title: "Test",
      notification_type: "invalid"
    )
    assert_not notification.valid?
  end

  test "unread scope" do
    unread = Notification.unread
    assert unread.include?(notifications(:unread_notification))
    assert_not unread.include?(notifications(:read_notification))
  end

  test "recent scope returns notifications" do
    notifications = Notification.recent
    assert notifications.count > 0
    # Verify ordering by checking first record is not older than last
    assert notifications.first.created_at >= notifications.last.created_at
  end

  test "read? returns true when read_at present" do
    assert notifications(:read_notification).read?
    assert_not notifications(:unread_notification).read?
  end

  test "mark_read! sets read_at" do
    notification = notifications(:unread_notification)
    assert_nil notification.read_at
    notification.mark_read!
    assert_not_nil notification.reload.read_at
  end

  test "mark_read! does not update already read" do
    notification = notifications(:read_notification)
    original_read_at = notification.read_at
    notification.mark_read!
    assert_equal original_read_at.to_i, notification.reload.read_at.to_i
  end

  test "user has_many notifications" do
    user = users(:customer)
    assert user.notifications.count >= 1
  end
end
