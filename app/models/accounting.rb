class Accounting
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend ActiveModel::Callbacks

  attribute :user
  attribute :from, :date
  attribute :to, :date

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
    TotalBalance.new(user.accounts, user.preferred_currency).value
  end

  def incomes_amount
    return Money.zero(user.preferred_currency) unless valid?

    incomes = user.incomes.where(committed_date: from..to).includes(:destination)
    TransactionsAmount.new(incomes, user.preferred_currency).value
  end

  def expenses_amount
    return Money.zero(user.preferred_currency) unless valid?

    expenses = user.expenses.where(committed_date: from..to).includes(:source)
    TransactionsAmount.new(expenses, user.preferred_currency).value
  end

  private

  def set_default_values
    self.to ||= Date.current
    self.from ||= to.beginning_of_month
  end

  def user_is_user
    errors.add(:user, I18n.t("errors.messages.is_a", model: User.model_name.human)) unless user.is_a?(User)
  end
end
