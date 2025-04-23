module FileButtonComponent
  delegate :tag, to: :template

  DEFAULT_LABEL = "Choose a file".freeze

  def file_button(_wrapper_options = nil)
    tag.span(class: "file-cta") do
      tag.span(options[:label] || DEFAULT_LABEL, class: "file-label")
    end
  end
end

SimpleForm.include_component(FileButtonComponent)
