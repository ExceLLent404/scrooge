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

  def perform
    account.withdraw(amount)
  end

  def correct(new_amount)
    diff = new_amount - amount
    return if diff.zero?

    (diff < 0) ? account.deposit(diff.abs) : account.withdraw(diff)
  end

  def cancel
    account.deposit(amount)
  end
end
