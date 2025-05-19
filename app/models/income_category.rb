class IncomeCategory < Category
  has_many :incomes, as: :source, dependent: :delete_all
  has_many :transactions, as: :source
end
