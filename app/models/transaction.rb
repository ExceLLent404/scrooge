class Transaction < ApplicationRecord
  include FaithfulSTI
  include HasCurrency

  TYPES = %w[Income Expense].freeze

  def self.ransackable_attributes(_auth_object = nil)
    %w[type committed_date comment] + _ransack_aliases.keys
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[source destination]
  end

  def self.ransortable_attributes(_auth_object = nil)
    %w[committed_date created_at]
  end

  normalizes :comment, with: ->(comment) { comment.present? ? comment.strip : nil }

  monetize :amount_cents, with_model_currency: :currency, numericality: {greater_than: 0}

  has_currency :currency, normalize: true

  belongs_to :user
  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  validates :currency, comparison: {
    equal_to: ->(transaction) { transaction.send(:account_currency) },
    message: ->(transaction, _data) { I18n.t("errors.messages.be", expected: transaction.send(:account_currency).to_s) }
  }, if: :account_currency
  validates :committed_date, presence: true
  validates :committed_date, comparison: {
    less_than_or_equal_to: ->(_) { Date.current },
    message: I18n.t("errors.messages.not_greater_than", count: "the current date")
  }
  validate do
    %i[source destination].each do |attribute|
      type_matching(attribute)
      ownership_of(attribute)
    end
  end

  after_initialize :set_currency, if: :new_record?
  after_initialize :set_appropriate_source_type, unless: :source_type?
  after_initialize :set_appropriate_destination_type, unless: :destination_type?

  ransack_alias :account, :source_of_Account_type_id_or_destination_of_Account_type_id
  ransack_alias :income_category, :source_of_Category_type_id
  ransack_alias :expense_category, :destination_of_Category_type_id

  # Sets the correct type for the polymorphic association with a source model that may use STI
  def source_type=(class_name)
    super(class_name.constantize.base_class.to_s)
  end

  # Sets the correct type for the polymorphic association with a destination model that may use STI
  def destination_type=(class_name)
    super(class_name.constantize.base_class.to_s)
  end

  # :nocov:

  def perform
    raise "Not implemented"
  end

  def correct(_new_amount)
    raise "Not implemented"
  end

  def cancel
    raise "Not implemented"
  end

  # :nocov:

  private

  def type_matching(attribute)
    association = public_send(attribute)
    klass = self.class.const_get("#{attribute.upcase}_TYPE").constantize
    model = klass.model_name.human
    errors.add(attribute, I18n.t("errors.messages.is_an", model:)) unless association.is_a?(klass)
  end

  def ownership_of(attribute)
    association = public_send(attribute)
    return if user.nil? || association.nil?
    return if (user.persisted? || association.persisted?) && user_id == association.user_id
    return if user == association.user

    errors.add(attribute, I18n.t("errors.messages.ownership", model: User.model_name.human))
  end

  def account_currency
    account.is_a?(Account) ? account.currency : nil
  end

  def sync_currency
    self.currency = account_currency
  end

  def set_appropriate_source_type
    self.source_type = self.class::SOURCE_TYPE
  end

  def set_appropriate_destination_type
    self.destination_type = self.class::DESTINATION_TYPE
  end
end
