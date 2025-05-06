class ExpenseCategoryDecorator < CategoryDecorator
  delegate_all

  def color
    "danger"
  end
end
