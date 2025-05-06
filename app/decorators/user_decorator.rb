class UserDecorator < ApplicationDecorator
  delegate_all

  def name
    explicit_name = super
    implicit_name = email.split("@").first
    explicit_name.presence || implicit_name
  end
end
