class Notification < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :notification_type, presence: true, inclusion: { in: %w[info order promo system] }

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def read?
    read_at.present?
  end

  def mark_read!
    update!(read_at: Time.current) unless read?
  end
end
