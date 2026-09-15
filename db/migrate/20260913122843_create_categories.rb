class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name,       null: false
      t.string :slug,       null: false
      t.integer :position,  null: false, default: 0
      t.references :parent, foreign_key: { to_table: :categories }, null: true

      t.timestamps
    end

    add_index :categories, :slug, unique: true
  end
end
