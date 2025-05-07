class ExpenseCategory < Category
  has_many :expenses, as: :destination, dependent: :delete_all
end
