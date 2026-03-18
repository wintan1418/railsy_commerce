class ThemeSetting < ApplicationRecord
  GROUPS = %w[general colors hero header footer social].freeze
  SETTING_TYPES = %w[text color image boolean select].freeze

  validates :key, presence: true, uniqueness: true
  validates :label, presence: true
  validates :group, presence: true, inclusion: { in: GROUPS }
  validates :setting_type, presence: true, inclusion: { in: SETTING_TYPES }

  scope :by_group, ->(group) { where(group: group).order(:position) }
  scope :ordered, -> { order(:group, :position) }

  def self.get(key, default = nil)
    find_by(key: key)&.value || default
  end

  def self.set(key, value)
    record = find_by(key: key)
    record&.update(value: value)
  end

  def boolean?
    setting_type == "boolean"
  end

  def color?
    setting_type == "color"
  end

  def image?
    setting_type == "image"
  end

  def select?
    setting_type == "select"
  end
end
