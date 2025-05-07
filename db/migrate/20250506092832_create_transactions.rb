class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.string :type, null: false
      t.integer :amount_cents, null: false
      t.text :comment
      t.date :committed_date, null: false
      t.references :source, polymorphic: true, null: false
      t.references :destination, polymorphic: true, null: false
      t.references :user, null: false

      t.timestamps
    end

    add_foreign_key :transactions, :users, on_update: :cascade, on_delete: :cascade
  end
end
