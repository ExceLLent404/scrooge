class IncomeCategoriesDecorator < CategoriesDecorator
  def human_type
    IncomeCategory.model_name.human.pluralize
  end
end
