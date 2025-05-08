class CategoryDecorator < ApplicationDecorator
  delegate_all

  def human_type
    model_name.human.downcase
  end

  def name_text_weight
    "has-text-weight-semibold"
  end
end
