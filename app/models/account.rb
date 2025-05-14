class Account < ApplicationRecord
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
  normalizes :currency, with: ->(currency) { currency.upcase }

  monetize :balance_cents,
    with_model_currency: :currency,
    numericality: {greater_than_or_equal_to: 0, message: I18n.t("errors.messages.not_less_than", count: 0)}

  belongs_to :user

  has_many :incomes, as: :destination, dependent: :delete_all
  has_many :expenses, as: :source, dependent: :delete_all

  validates :name, presence: true
  validates :currency, presence: {
    message: I18n.t(
      "errors.messages.one_of",
      list: Money::Currency.all.to_sentence(last_word_connector: I18n.t("support.array.enum_connector"))
    )
  }

  def currency=(value)
    currency = suppress(Money::Currency::UnknownCurrency) { value&.to_currency }
    super(currency)
  end

  def currency
    super&.to_currency
  end

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
