class AccountDecorator < ApplicationDecorator
  delegate_all

  def name_text_weight
    "has-text-weight-normal"
  end

  # @return [String] account label for selection field
  def to_label
    "#{name} #{balance.format}"
  end
end
