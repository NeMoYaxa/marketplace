class Listing < ApplicationRecord
  CITIES = ApplicationController.helpers.major_cities.freeze

  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :images

  enum :status, { active: 0, sold: 1, archived: 2 }

  scope :by_min_price, ->(value) {
    price = price_value(value)
    price ? where("price >= ?", price) : all
  }
  scope :by_max_price, ->(value) {
    price = price_value(value)
    price ? where("price <= ?", price) : all
  }
  scope :by_city, ->(value) { value.present? ? where(city: value) : all }
  scope :search, ->(query) {
    query = query.to_s.strip
    query.present? ? where("title ILIKE :q OR description ILIKE :q", q: "%#{sanitize_sql_like(query)}%") : all
  }
  scope :sorted_by, ->(value) {
    {
      "date" => { created_at: :desc },
      "price_asc" => { price: :asc },
      "price_desc" => { price: :desc }
    }.fetch(value.to_s, { created_at: :desc }).then { |order| order(order) }
  }

  def self.price_value(value)
    price = Integer(value, 10)
    price if price >= 0
  rescue ArgumentError, TypeError
    nil
  end

  validates :title, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
