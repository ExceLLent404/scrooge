class Category < ApplicationRecord
  include FaithfulSTI

  def self.ransackable_attributes(_auth_object = nil)
    %w[id]
  end

  normalizes :name, with: ->(name) { name.squish }

  belongs_to :user

  validates :name, presence: true
end
