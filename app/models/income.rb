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
end
