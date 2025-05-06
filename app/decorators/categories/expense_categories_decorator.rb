class ExpenseCategoriesDecorator < CategoriesDecorator
  def human_type
    ExpenseCategory.model_name.human.pluralize
  end
end
