class Banner < ApplicationRecord
  has_one_attached :image

  validates :title, presence: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :id) }
  scope :current, -> {
    now = Time.current
    where("starts_at IS NULL OR starts_at <= ?", now)
      .where("ends_at IS NULL OR ends_at >= ?", now)
  }
  scope :live, -> { active.current.ordered }

  def image_url
    return nil unless image.attached?
    Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
  end
end
