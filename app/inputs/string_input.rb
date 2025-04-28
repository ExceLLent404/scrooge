class StringInput < SimpleForm::Inputs::StringInput
  EMAIL_OPTIONS = {
    required: true,
    input_html: {autocomplete: "email"}
  }.freeze

  def initialize(builder, attribute_name, column, input_type, options = {})
    @attribute_name = attribute_name

    options.reverse_merge!(EMAIL_OPTIONS) if email?

    super
  end

  private

  def email?
    attribute_name == :email
  end
end
