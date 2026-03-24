module Storefront
  class ChatController < ApplicationController
    include CartManagement
    allow_unauthenticated_access

    def create
      conversation_id = chat_conversation_id
      message = ChatMessage.create!(
        user: current_user,
        guest_token: current_user ? nil : guest_chat_token,
        sender_type: "customer",
        body: params[:message],
        conversation_id: conversation_id
      )

      # Auto bot reply
      bot_response = ChatMessage.bot_reply(params[:message])
      ChatMessage.create!(
        sender_type: "bot",
        body: bot_response,
        conversation_id: conversation_id
      )

      redirect_back fallback_location: root_path, notice: nil
    end

    def messages
      @messages = ChatMessage.for_conversation(chat_conversation_id)
      render partial: "storefront/chat/messages", locals: { messages: @messages }
    end

    private

    def chat_conversation_id
      if current_user
        "user_#{current_user.id}"
      else
        "guest_#{guest_chat_token}"
      end
    end

    def guest_chat_token
      cookies[:chat_token] ||= SecureRandom.hex(16)
      cookies[:chat_token]
    end
  end
end
