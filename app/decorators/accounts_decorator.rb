class AccountsDecorator < Draper::CollectionDecorator
  def selection_prompt
    "Select account"
  end
end
