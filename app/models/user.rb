class User < ApplicationRecord
  normalizes :name, with: ->(name) { name.present? ? name.squish : nil }
  normalizes :email, with: ->(email) { email.strip.downcase }

  has_one_attached :avatar

  has_many :accounts, dependent: :delete_all
  has_many :categories, dependent: :delete_all
  has_many :income_categories
  has_many :expense_categories
  has_many :transactions, dependent: :delete_all
  has_many :incomes
  has_many :expenses

  validates :time_zone, inclusion: {in: ActiveSupport::TimeZone.all.map(&:name), message: I18n.t("errors.messages.invalid")}

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable
end
