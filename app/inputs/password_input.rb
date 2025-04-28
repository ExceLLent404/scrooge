class PasswordInput < SimpleForm::Inputs::PasswordInput
  PASSWORD_OPTIONS = {
    required: true,
    minlength: true,
    maxlength: true,
    input_html: {autocomplete: "current-password"}
  }.freeze

  def initialize(builder, attribute_name, column, input_type, options = {})
    options.reverse_merge!(PASSWORD_OPTIONS)
    super
  end
end
