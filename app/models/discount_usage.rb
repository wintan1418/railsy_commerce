class DiscountUsage < ApplicationRecord
  belongs_to :discount, counter_cache: false
  belongs_to :user, optional: true
  belongs_to :order

  validates :used_at, presence: true
end
