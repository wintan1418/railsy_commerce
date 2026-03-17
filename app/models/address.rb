class Address < ApplicationRecord
  belongs_to :user, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :country_code, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def one_line
    parts = [ address_line_1, address_line_2, city, state, postal_code, country_code ]
    parts.compact_blank.join(", ")
  end
end
