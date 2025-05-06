class IncomeCategoryDecorator < CategoryDecorator
  delegate_all

  def color
    "success"
  end
end
