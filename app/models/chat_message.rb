class ChatMessage < ApplicationRecord
  belongs_to :user, optional: true

  validates :body, presence: true
  validates :conversation_id, presence: true
  validates :sender_type, inclusion: { in: %w[customer agent bot] }

  scope :for_conversation, ->(id) { where(conversation_id: id).order(:created_at) }
  scope :unread, -> { where(read_at: nil) }
  scope :recent_conversations, -> {
    select("DISTINCT ON (conversation_id) *")
      .order("conversation_id, created_at DESC")
  }

  BOT_RESPONSES = {
    "shipping" => "We offer Standard (5-7 days, $9.99), Express (1-2 days, $24.99), and Free shipping on orders over $75. You can track your order anytime at the Track Order page.",
    "return" => "We have a 30-day hassle-free return policy. Items must be in original condition. Visit your Account → Orders to start a return request.",
    "payment" => "We accept all major credit cards (Visa, Mastercard, Amex) via Stripe, and Google Pay. All transactions are secured with 256-bit SSL encryption.",
    "order" => "You can check your order status in My Account → Orders, or use the Track Order feature in the main navigation. Enter your order number to see real-time delivery updates.",
    "discount" => "Check our Sale section for current deals! We regularly offer seasonal promotions. Subscribe to our newsletter for exclusive discount codes.",
    "contact" => "You can reach us at wintan1418@gmail.com or WhatsApp: +234 814 580 4206. We typically respond within 24 hours.",
    "hours" => "Our customer service is available 24/7 through this chat. For phone support, we're available Monday-Friday, 9AM-6PM WAT.",
    "solar" => "We offer complete solar solutions: panels (200W-400W), lithium batteries (100Ah-200Ah), inverters (3.5KVA-5KVA), and professional installation. Visit our Solar & Renewable Energy category for details and pricing.",
    "account" => "You can manage your account at My Account. There you can view orders, manage addresses, edit your profile, and check your wishlist."
  }.freeze

  def self.bot_reply(message)
    msg = message.downcase
    BOT_RESPONSES.each do |keyword, response|
      return response if msg.include?(keyword)
    end
    "Thanks for your message! Our team will get back to you shortly. In the meantime, you can check our FAQ page for quick answers, or try asking about: shipping, returns, payments, orders, discounts, or solar products."
  end
end
