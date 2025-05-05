class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.integer :balance_cents, null: false, default: 0
      t.references :user, null: false

      t.timestamps
    end

    add_foreign_key :accounts, :users, on_update: :cascade, on_delete: :cascade
  end
end
