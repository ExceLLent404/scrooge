class TransactionDecorator < ApplicationDecorator
  delegate_all
  decorates_association :source
  decorates_association :destination

  def human_type
    model_name.human.downcase
  end
end
