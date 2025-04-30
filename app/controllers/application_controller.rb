class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  private

  # Method used by sessions controller to sign out a user.
  # @see Devise::Controllers::Helpers#after_sign_out_path_for
  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
