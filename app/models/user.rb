class User < ApplicationRecord
  normalizes :name, with: ->(name) { name.present? ? name.squish : nil }
  normalizes :email, with: ->(email) { email.strip.downcase }

  has_many :accounts, dependent: :delete_all
  has_many :categories, dependent: :delete_all
  has_many :income_categories
  has_many :expense_categories

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable
end
