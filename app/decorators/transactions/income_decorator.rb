class IncomeDecorator < TransactionDecorator
  delegate_all

  def color
    "success"
  end

  def possible_sources
    user.income_categories.order(created_at: :asc).decorate
  end

  def possible_destinations
    user.accounts.order(created_at: :asc).decorate
  end
end
