class DigitalDownload < ApplicationRecord
  belongs_to :order_item

  has_one :variant, through: :order_item
  has_one :order, through: :order_item

  validates :access_token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  def product
    order_item.variant.product
  end

  def files
    product.digital_files
  end

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def available?
    !expired?
  end

  def record_download!
    update!(
      download_count: download_count + 1,
      last_downloaded_at: Time.current
    )
  end

  private

  def generate_token
    self.access_token ||= SecureRandom.urlsafe_base64(24)
  end
end
