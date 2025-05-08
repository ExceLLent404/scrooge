class ExpenseCategoriesDecorator < CategoriesDecorator
  def human_type
    ExpenseCategory.model_name.human.pluralize
  end

  def selection_prompt
    "Select expense category"
  end
end
