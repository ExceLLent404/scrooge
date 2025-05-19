class ExpenseCategory < Category
  has_many :expenses, as: :destination, dependent: :delete_all
  has_many :transactions, as: :destination
end
