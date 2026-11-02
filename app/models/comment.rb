class Comment < ApplicationRecord
  belongs_to :listing
  belongs_to :user

  validates :body, presence: true, length: { in: 1..1000 }

  after_create_commit do
    broadcast_append_to [listing, :comments], target: ActionView::RecordIdentifier.dom_id(listing, :comments_list)
    broadcast_update_to [listing, :comments], target: ActionView::RecordIdentifier.dom_id(listing, :comments_count), content: listing.comments.count.to_s
  end

  after_destroy_commit do
    broadcast_remove_to [listing, :comments]
    broadcast_update_to [listing, :comments], target: ActionView::RecordIdentifier.dom_id(listing, :comments_count), content: listing.comments.count.to_s
  end
end
