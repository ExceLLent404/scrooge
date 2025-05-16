class User < ApplicationRecord
  include HasCurrency

  normalizes :name, with: ->(name) { name.present? ? name.squish : nil }
  normalizes :email, with: ->(email) { email.strip.downcase }

  has_currency :preferred_currency, normalize: true

  has_one_attached :avatar do |attachable|
    attachable.variant :thumbnail, resize_to_fill: [32, 32], saver: {quality: 100}
    attachable.variant :profile, resize_to_fill: [128, 128], saver: {quality: 100}
  end

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

  protected

  # Devise internal method overridden to send a notification/mail in background
  def send_devise_notification(notification, *)
    devise_mailer.send(notification, self, *).deliver_later
  end

  # The original Devise `send_devise_notification` method
  def send_devise_notification_now(notification, *)
    devise_mailer.send(notification, self, *).deliver_now
  end

  # Devise internal method overridden to not log a password reset token by ActiveJob:
  # https://github.com/heartcombo/devise#password-reset-tokens-and-rails-logs
  def send_reset_password_instructions_notification(token)
    send_devise_notification_now(:reset_password_instructions, token, {})
  end
end
