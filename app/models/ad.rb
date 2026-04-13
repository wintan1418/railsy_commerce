class Ad < ApplicationRecord
  has_one_attached :image

  PLACEMENTS = %w[home_top home_mid home_bottom category_sidebar].freeze

  validates :title, presence: true
  validates :placement, presence: true, inclusion: { in: PLACEMENTS }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :id) }
  scope :current, -> {
    now = Time.current
    where("starts_at IS NULL OR starts_at <= ?", now)
      .where("ends_at IS NULL OR ends_at >= ?", now)
  }
  scope :live, -> { active.current.ordered }
  scope :for_placement, ->(placement) { where(placement: placement) }
end
