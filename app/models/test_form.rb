class TestForm
  include ActiveModel::Model

  attr_accessor :field, :error_field

  validates :error_field, presence: true
end
