class ExpenseDecorator < TransactionDecorator
  delegate_all

  def color
    "danger"
  end

  def possible_sources
    user.accounts.order(created_at: :asc).decorate
  end

  def possible_destinations
    user.expense_categories.order(created_at: :asc).decorate
  end
end
