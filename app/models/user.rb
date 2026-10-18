class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :listings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_listings, through: :favorites, source: :listing
  has_one_attached :avatar

  enum :role, { user: 0, admin: 1 }

  validates :name, presence: true, length: { minimum: 4, maximum: 50 }
  validates :phone, format: { with: /\A\+?\d{10,15}\z/ }, allow_blank: true
  validate :avatar_format

  private

  def avatar_format
    return unless avatar.attached?

    errors.add(:avatar, "должен быть в формате JPEG, PNG или WebP") unless avatar.content_type.in?(%w[image/jpeg image/png image/webp])
    errors.add(:avatar, "не должен превышать 5 МБ") if avatar.byte_size > 5.megabytes
  end
end
