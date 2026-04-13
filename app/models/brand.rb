class Brand < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_one_attached :logo
  has_many :products, dependent: :nullify

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :featured, -> { where(featured: true) }
  scope :ordered, -> { order(:position, :name) }

  def products_count
    products.where(status: "active").count
  end
end
