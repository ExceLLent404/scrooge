class Account < ApplicationRecord
  include HasCurrency

  class NegativeAmount < StandardError
    def initialize(amount)
      super(I18n.t("errors.messages.account.negative_amount", amount:))
    end
  end

  class NotEnoughBalance < StandardError
    def initialize(name, balance, amount)
      super(I18n.t("errors.messages.account.not_enough_balance", name:, balance: balance.format, amount: amount.format))
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[]
  end

  normalizes :name, with: ->(name) { name.squish }

  monetize :balance_cents,
    with_model_currency: :currency,
    numericality: {greater_than_or_equal_to: 0, message: I18n.t("errors.messages.not_less_than", count: 0)}

  has_currency :currency, normalize: true

  belongs_to :user

  has_many :incomes, as: :destination, dependent: :delete_all
  has_many :expenses, as: :source, dependent: :delete_all

  validates :name, presence: true

  def deposit(amount)
    raise NegativeAmount.new(amount) if amount < 0

    self.balance += amount
  end

  def withdraw(amount)
    raise NegativeAmount.new(amount) if amount < 0
    raise NotEnoughBalance.new(name, balance, amount) if balance < amount

    self.balance -= amount
  end
end
