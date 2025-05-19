class AddCurrencyToTransactions < ActiveRecord::Migration[7.2]
  def up
    add_column :transactions, :currency, :string
    set_currency_for_transactions
    change_column_null :transactions, :currency, false
  end

  def down
    remove_column :transactions, :currency
  end

  private

  def set_currency_for_transactions
    Money::Currency.all.each do |currency| # rubocop:disable Rails/FindEach
      ids = Account.where(currency:).ids
      Income.where(destination_id: ids).update_all(currency:)
      Expense.where(source_id: ids).update_all(currency:)
    end
  end
end
