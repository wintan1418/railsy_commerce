class Review < ApplicationRecord
  belongs_to :product, counter_cache: true
  belongs_to :user

  enum :status, { pending: "pending", approved: "approved", rejected: "rejected" }

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :product_id, message: "has already reviewed this product" }

  scope :approved, -> { where(status: :approved) }
  scope :recent, -> { order(created_at: :desc) }
end
