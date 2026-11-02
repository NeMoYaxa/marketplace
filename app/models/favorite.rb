class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :listing, counter_cache: true

  validates :user_id, uniqueness: { scope: :listing_id }

  after_create_commit do
    broadcast_replace_to [listing, :favorites], target: ActionView::RecordIdentifier.dom_id(listing, :favorite_count), partial: "favorites/count", locals: { listing: listing }
  end

  after_destroy_commit do
    broadcast_replace_to [listing, :favorites], target: ActionView::RecordIdentifier.dom_id(listing, :favorite_count), partial: "favorites/count", locals: { listing: listing }
  end
end
