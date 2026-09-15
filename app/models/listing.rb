class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many_attached :images

  enum :status, { active: 0, sold: 1, archived: 2 }

  validates :title, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
