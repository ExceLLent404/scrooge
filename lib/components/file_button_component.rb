module FileButtonComponent
  delegate :tag, to: :template

  DEFAULT_ICON = "fa-solid fa-file-arrow-up".freeze
  DEFAULT_LABEL = "Choose a file".freeze

  def file_button(_wrapper_options = nil)
    button + file_name
  end

  private

  def button
    tag.span(class: "file-cta") do
      file_icon + button_label
    end
  end

  def file_icon
    tag.span(class: "file-icon") do
      tag.i(class: options[:icon] || DEFAULT_ICON)
    end
  end

  def button_label
    tag.span(options[:label] || DEFAULT_LABEL, class: "file-label")
  end

  def file_name
    tag.span("No file uploaded", class: "file-name", data: {file_target: :name})
  end
end

SimpleForm.include_component(FileButtonComponent)
