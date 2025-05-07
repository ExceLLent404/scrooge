class Transaction < ApplicationRecord
  include FaithfulSTI

  normalizes :comment, with: ->(comment) { comment.present? ? comment.strip : nil }

  monetize :amount_cents, numericality: {greater_than: 0}

  belongs_to :user
  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  validates :committed_date, presence: true
end
