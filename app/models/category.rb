class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true
  has_many :subcategories, class_name: "Category", foreign_key: :parent_id, dependent: :nullify
  has_many :listings, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
end
