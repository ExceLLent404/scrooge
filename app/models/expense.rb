class Expense < Transaction
  SOURCE_TYPE = "Account".freeze
  DESTINATION_TYPE = "ExpenseCategory".freeze

  def account
    source
  end

  def account=(expense_account)
    self.source = expense_account
  end

  def category
    destination
  end

  def category=(expense_category)
    self.destination = expense_category
  end
end
