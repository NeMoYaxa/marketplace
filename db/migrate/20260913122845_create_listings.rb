class CreateListings < ActiveRecord::Migration[8.1]
  def change
    create_table :listings do |t|
      t.references :user,     null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.string :title,   null: false
      t.text :description
      t.integer :price
      t.integer :status, null: false, default: 0
      t.string :city

      t.timestamps
    end

    add_index :listings, :status
    add_index :listings, :city
    add_index :listings, [ :category_id, :status ]
  end
end
