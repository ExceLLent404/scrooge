module FileButtonComponent
  delegate :tag, to: :template

  DEFAULT_ICON = "fa-solid fa-file-arrow-up".freeze
  DEFAULT_LABEL = "Choose a file".freeze

  def file_button(_wrapper_options = nil)
    tag.span(class: "file-cta") do
      file_icon + button_label
    end
  end

  private

  def file_icon
    tag.span(class: "file-icon") do
      tag.i(class: options[:icon] || DEFAULT_ICON)
    end
  end

  def button_label
    tag.span(options[:label] || DEFAULT_LABEL, class: "file-label")
  end
end

SimpleForm.include_component(FileButtonComponent)
