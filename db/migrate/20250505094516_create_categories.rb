class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :type, null: false
      t.string :name, null: false
      t.references :user, null: false

      t.timestamps
    end

    add_foreign_key :categories, :users, on_update: :cascade, on_delete: :cascade
  end
end
