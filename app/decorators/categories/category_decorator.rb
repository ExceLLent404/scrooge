class CategoryDecorator < ApplicationDecorator
  delegate_all

  def human_type
    model_name.human.downcase
  end
end
