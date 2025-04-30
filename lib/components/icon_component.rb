module IconComponent
  delegate :tag, to: :template

  def icon(_wrapper_options = nil)
    return if options[:icon].blank?

    tag.span(class: icon_class) do
      tag.i(class: options[:icon])
    end
  end

  private

  def icon_class
    ["icon", options[:icon_class]].compact_blank.join(" ")
  end
end

SimpleForm.include_component(IconComponent)
