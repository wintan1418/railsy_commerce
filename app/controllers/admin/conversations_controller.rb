module Admin
  class ConversationsController < BaseController
    def index
      @conversations = ChatMessage.select("conversation_id, MAX(created_at) as last_at, COUNT(*) as msg_count")
        .group(:conversation_id)
        .order("last_at DESC")

      @unread_count = ChatMessage.where(sender_type: "customer").unread.count
    end

    def show
      @conversation_id = params[:id]
      @messages = ChatMessage.for_conversation(@conversation_id)
      @messages.where(sender_type: "customer").unread.update_all(read_at: Time.current)
    end

    def reply
      ChatMessage.create!(
        user: current_user,
        sender_type: "agent",
        body: params[:message],
        conversation_id: params[:id]
      )
      redirect_to admin_conversation_path(params[:id]), notice: "Reply sent."
    end
  end
end
