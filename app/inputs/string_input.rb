class StringInput < SimpleForm::Inputs::StringInput
  EMAIL_OPTIONS = {
    required: true,
    icon: "fas fa-envelope",
    control_html: {class: "has-icons-left"},
    input_html: {autocomplete: "email"}
  }.freeze

  USER_NAME_OPTIONS = {
    icon: "fas fa-user",
    control_html: {class: "has-icons-left"},
    input_html: {autocomplete: "name"}
  }.freeze

  def initialize(builder, attribute_name, column, input_type, options = {})
    @builder = builder
    @attribute_name = attribute_name

    if email?
      options.reverse_merge!(EMAIL_OPTIONS)
      options[:icon_class] = [options[:icon_class], "is-left"].compact_blank.join(" ")
    end

    if user_name?
      options.reverse_merge!(USER_NAME_OPTIONS)
      options[:icon_class] = [options[:icon_class], "is-left"].compact_blank.join(" ")
    end

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
