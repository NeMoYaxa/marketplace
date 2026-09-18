class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :listings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_listings, through: :favorites, source: :listing

  enum :role, { user: 0, admin: 1 }

  validates :name, presence: true, length: { minimum: 4, maximum: 50 }
  validates :phone, format: { with: /\A\+?\d{10,15}\z/ }, allow_blank: true
end
