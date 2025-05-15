class ApplicationController < ActionController::Base
  include Pagy::Backend

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :set_sentry_user, if: :current_user

  around_action :set_time_zone, if: :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def current_user
    @decorated_user ||= super.decorate if super
  end

  private

  def set_sentry_user
    Sentry.set_user(email: current_user.email)
  end

  def set_time_zone(&)
    Time.use_zone(current_user.time_zone, &)
  end

  def record_not_found(error)
    path = send(:"#{error.model.downcase.pluralize}_path")
    redirect_back_or_to path, alert: "#{error.model} not found"
  end

  # Method used by sessions controller to sign out a user.
  # @see Devise::Controllers::Helpers#after_sign_out_path_for
  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
