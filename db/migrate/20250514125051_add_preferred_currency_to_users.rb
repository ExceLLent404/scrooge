class AddPreferredCurrencyToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :preferred_currency, :string, null: false, default: "USD"
  end
end
