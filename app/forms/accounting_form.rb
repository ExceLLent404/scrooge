class AccountingForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend ActiveModel::Callbacks

  attribute :from, :date
  attribute :to, :date

  define_model_callbacks :initialize, only: :after

  def initialize(attributes = {})
    run_callbacks(:initialize) do
      super
    end
  end

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

  private

  def set_default_values
    self.to ||= Date.current
    self.from ||= to.beginning_of_month
  end
end
