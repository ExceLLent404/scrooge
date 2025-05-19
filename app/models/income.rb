class Income < Transaction
  SOURCE_TYPE = "IncomeCategory".freeze
  DESTINATION_TYPE = "Account".freeze

  def destination_id=(id)
    super
    sync_currency
  end

  def destination=(new_destination)
    super
    sync_currency
  end

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

  private

  def set_currency
    self.destination = Account.find_by(id: destination_id) if destination.nil? && destination_id.present?
    sync_currency
  end
end
