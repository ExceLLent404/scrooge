class Category < ApplicationRecord
  include FaithfulSTI

  normalizes :name, with: ->(name) { name.squish }

  belongs_to :user

  validates :name, presence: true
end
