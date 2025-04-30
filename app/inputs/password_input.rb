class PasswordInput < SimpleForm::Inputs::PasswordInput
  PASSWORD_OPTIONS = {
    required: true,
    minlength: true,
    maxlength: true,
    icon: "fas fa-lock",
    control_html: {class: "has-icons-left"},
    input_html: {autocomplete: "current-password"}
  }.freeze

  def initialize(builder, attribute_name, column, input_type, options = {})
    options.reverse_merge!(PASSWORD_OPTIONS)
    options[:icon_class] = [options[:icon_class], "is-left"].compact_blank.join(" ")
    super
  end
end
