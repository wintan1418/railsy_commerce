class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :variants, through: :cart_items

  before_create :generate_token

  scope :active, -> { where(completed_at: nil) }
  scope :abandoned, -> { active.where(updated_at: ..24.hours.ago) }

  def subtotal
    cart_items.includes(variant: :product).sum { |item| item.subtotal }
  end

  def item_count
    cart_items.sum(:quantity)
  end

  def empty?
    cart_items.empty?
  end

  def complete!
    update!(completed_at: Time.current)
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(32)
  end
end
