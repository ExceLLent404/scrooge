class AccountDecorator < ApplicationDecorator
  delegate_all

  def name_text_weight
    "has-text-weight-normal"
  end
end
