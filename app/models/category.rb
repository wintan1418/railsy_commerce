class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: :parent_id, dependent: :nullify
  has_many :products, dependent: :nullify

  has_one_attached :image

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :roots, -> { where(parent_id: nil) }
  scope :ordered, -> { order(:position, :name) }
end
