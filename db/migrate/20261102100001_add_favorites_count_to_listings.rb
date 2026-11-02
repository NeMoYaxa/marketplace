class AddFavoritesCountToListings < ActiveRecord::Migration[8.1]
  def up
    add_column :listings, :favorites_count, :integer, null: false, default: 0
    execute <<~SQL
      UPDATE listings
      SET favorites_count = (
        SELECT COUNT(*)
        FROM favorites
        WHERE favorites.listing_id = listings.id
      )
    SQL
  end

  def down
    remove_column :listings, :favorites_count
  end
end
