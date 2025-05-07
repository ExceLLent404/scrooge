class Account < ApplicationRecord
  normalizes :name, with: ->(name) { name.squish }

  monetize :balance_cents,
    numericality: {greater_than_or_equal_to: 0, message: I18n.t("errors.messages.not_less_than", count: 0)}

  belongs_to :user

  has_many :incomes, as: :destination, dependent: :delete_all
  has_many :expenses, as: :source, dependent: :delete_all

  validates :name, presence: true
end
