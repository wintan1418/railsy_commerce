class Product < ApplicationRecord
  include PgSearch::Model

  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :category, optional: true
  has_many :variants, -> { order(:position) }, dependent: :destroy
  has_many :product_option_types, -> { order(:position) }, dependent: :destroy
  has_many :option_types, through: :product_option_types

  has_many :reviews, dependent: :destroy
  has_many :product_relations, dependent: :destroy
  has_many :related_products, through: :product_relations
  has_many_attached :images

  enum :status, { draft: "draft", active: "active", archived: "archived" }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :status, presence: true

  pg_search_scope :search,
    against: { name: "A", description: "B" },
    associated_against: { category: :name },
    using: { tsearch: { prefix: true, dictionary: "english" } }

  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :ordered, -> { order(created_at: :desc) }

  def master_variant
    variants.find_by(is_master: true) || variants.first
  end

  def price
    master_variant&.price
  end

  def display_price
    master_variant&.price&.format
  end

  def in_stock?
    variants.any?(&:in_stock?)
  end

  def average_rating
    reviews.approved.average(:rating)&.round(1)
  end

  def reviews_count
    reviews.approved.count
  end

  def related(limit: 4)
    explicit = related_products.active.includes(:category, variants: :stock_items).limit(limit)
    return explicit if explicit.any?

    # Fallback to same-category products
    Product.active
      .where(category_id: category_id)
      .where.not(id: id)
      .includes(:category, variants: :stock_items)
      .limit(limit)
  end
end
