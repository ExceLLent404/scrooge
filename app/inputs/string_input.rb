class StringInput < SimpleForm::Inputs::StringInput
  EMAIL_OPTIONS = {
    required: true,
    input_html: {autocomplete: "email"}
  }.freeze

  USER_NAME_OPTIONS = {
    input_html: {autocomplete: "name"}
  }.freeze

  def initialize(builder, attribute_name, column, input_type, options = {})
    @builder = builder
    @attribute_name = attribute_name

    options.reverse_merge!(EMAIL_OPTIONS) if email?
    options.reverse_merge!(USER_NAME_OPTIONS) if user_name?

    super
  end

  private

  def email?
    attribute_name == :email
  end

  def user_name?
    attribute_name == :name && object.is_a?(User)
  end
end
