class Income < Transaction
  SOURCE_TYPE = "IncomeCategory".freeze
  DESTINATION_TYPE = "Account".freeze

  def category
    source
  end

  def category=(income_category)
    self.source = income_category
  end

  def account
    destination
  end

  def account=(income_account)
    self.destination = income_account
  end

  def perform
    account.deposit(amount)
  end

  def correct(new_amount)
    diff = new_amount - amount
    return if diff.zero?

    (diff > 0) ? account.deposit(diff) : account.withdraw(diff.abs)
  end

  def cancel
    account.withdraw(amount)
  end
end
