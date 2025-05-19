class AccountingDecorator < ApplicationDecorator
  delegate_all

  # Returns not `nil` so that {ActionDispatch::Http::URL#add_params} can use {#to_query}
  # @see ActiveModel::Conversion#to_param
  def to_param
    ""
  end

  # Converts an object into a string suitable for use as a URL query string, using the given key as the param name.
  # Needed for use in path helpers like: some_path(accounting:)
  def to_query(key)
    attributes.except("user").to_query(key)
  end
end
