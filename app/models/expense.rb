class Expense < Transaction
  SOURCE_TYPE = "Account".freeze
  DESTINATION_TYPE = "ExpenseCategory".freeze
end
