class FileInput < SimpleForm::Inputs::FileInput
  IMAGE_OPTIONS = {
    icon: "far fa-file-image",
    label: "Choose an image",
    input_html: {accept: "image/png, image/jpeg"}
  }.freeze

  def initialize(builder, attribute_name, column, input_type, options = {})
    @attribute_name = attribute_name
    options.reverse_merge!(IMAGE_OPTIONS) if image?
    super
  end

  private

  def image?
    attribute_name == :avatar
  end
end
