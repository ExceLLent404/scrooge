class Transaction < ApplicationRecord
  include FaithfulSTI

  normalizes :comment, with: ->(comment) { comment.present? ? comment.strip : nil }

  monetize :amount_cents, numericality: {greater_than: 0}

  belongs_to :user
  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  validates :committed_date, presence: true
  validate do
    %i[source destination].each { |attribute| type_matching(attribute) }
  end

  private

  def type_matching(attribute)
    association = public_send(attribute)
    klass = self.class.const_get("#{attribute.upcase}_TYPE").constantize
    model = klass.model_name.human
    errors.add(attribute, I18n.t("errors.messages.is_an", model:)) unless association.is_a?(klass)
  end
end
