class StockLocation < ApplicationRecord
  has_many :stock_items, dependent: :destroy

  validates :name, presence: true

  scope :active, -> { where(active: true) }

  def self.default_location
    find_by(default: true) || first
  end
end
