class IncomeCategoriesDecorator < CategoriesDecorator
  def human_type
    IncomeCategory.model_name.human.pluralize
  end

  def selection_prompt
    "Select income category"
  end
end
