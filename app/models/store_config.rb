class StoreConfig < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  def self.get(key, default = nil)
    find_by(key: key)&.value || defaults[key.to_s] || default
  end

  def self.set(key, value)
    record = find_or_initialize_by(key: key)
    record.update!(value: value)
  end

  def self.defaults
    @defaults ||= YAML.load_file(Rails.root.join("config/store.yml"), aliases: true).fetch(Rails.env, {})
  rescue Errno::ENOENT
    {}
  end

  def self.store_name
    get("store_name", "RailsyCommerce")
  end

  def self.store_currency
    get("store_currency", "USD")
  end

  def self.free_shipping_threshold
    get("free_shipping_threshold", "7500").to_i
  end
end
