class Accounting
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend ActiveModel::Callbacks
  include Draper::Decoratable
  include HasCurrency

  attribute :user
  attribute :currency
  attribute :from, :date
  attribute :to, :date

  has_currency :currency

  define_model_callbacks :initialize, only: :after

  def initialize(attributes = {})
    run_callbacks(:initialize) do
      super
    end
  end

  validate :user_is_user
  validates :from, comparison: {
    less_than_or_equal_to: ->(form) { [Date.current, form.to].min },
    message: ->(form, _data) do
      I18n.t(
        "errors.messages.not_greater_than",
        count: ([Date.current, form.to].min == Date.current) ? "the current date" : form.class.human_attribute_name(:to)
      )
    end
  }
  validates :to, comparison: {
    less_than_or_equal_to: ->(_) { Date.current },
    message: I18n.t("errors.messages.not_greater_than", count: "the current date")
  }

  after_initialize :set_default_values

  def total_funds
    validate
    errors.key?(:currency) ? zero_amount : TotalBalance.new(user.accounts, currency).value
  end

  def incomes_amount
    return zero_amount unless valid?

    incomes = user.incomes.where(committed_date: from..to)
    TransactionsAmount.new(incomes, currency).value
  end

  def expenses_amount
    return zero_amount unless valid?

    expenses = user.expenses.where(committed_date: from..to)
    TransactionsAmount.new(expenses, currency).value
  end

  def transactions_amount_by_category(category)
    return zero_amount unless valid?

    just_created = category.persisted? && category.id_previously_changed?
    category_transactions = just_created ? [] : category.transactions.where(user:, committed_date: from..to)
    TransactionsAmount.new(category_transactions, currency).value
  end

  def transactions_amounts_by_categories(categories)
    transactions = user.transactions.where(committed_date: from..to)
    valid? ? TransactionsAmountsByCategories.new(transactions, categories, currency).result : Hash.new { zero_amount }
  end

  private

  def set_default_values
    self.currency ||= user&.preferred_currency
    self.to ||= Date.current
    self.from ||= to.beginning_of_month
  end

  def user_is_user
    errors.add(:user, I18n.t("errors.messages.is_a", model: User.model_name.human)) unless user.is_a?(User)
  end

  def zero_amount
    validate
    zero_currency = errors.key?(:currency) ? Money.default_currency : currency
    Money.zero(zero_currency)
  end
end
