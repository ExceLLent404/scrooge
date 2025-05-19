class Expense < Transaction
  SOURCE_TYPE = "Account".freeze
  DESTINATION_TYPE = "ExpenseCategory".freeze

  def source_id=(id)
    super
    sync_currency
  end

  def source=(new_source)
    super
    sync_currency
  end

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

  private

  def set_currency
    self.source = Account.find_by(id: source_id) if source.nil? && source_id.present?
    sync_currency
  end
end
