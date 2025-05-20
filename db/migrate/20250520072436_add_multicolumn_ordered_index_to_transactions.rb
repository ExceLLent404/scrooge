class AddMulticolumnOrderedIndexToTransactions < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    add_index :transactions,
      %i[user_id committed_date created_at],
      order: {committed_date: :desc, created_at: :desc},
      name: "index_transactions_on_user_id_committed_date_created_at",
      algorithm: :concurrently

    remove_index :transactions, :user_id, algorithm: :concurrently
  end
end
