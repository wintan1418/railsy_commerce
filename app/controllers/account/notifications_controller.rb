module Account
  class NotificationsController < BaseController
    def index
      @notifications = current_user.notifications.recent.limit(50)
    end

    def mark_read
      notification = current_user.notifications.find(params[:id])
      notification.mark_read!
      redirect_to account_notifications_path, notice: "Notification marked as read."
    end

    def mark_all_read
      current_user.notifications.unread.update_all(read_at: Time.current)
      redirect_to account_notifications_path, notice: "All notifications marked as read."
    end
  end
end
