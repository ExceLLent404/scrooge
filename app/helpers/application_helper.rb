module ApplicationHelper
  attr_reader :pagy

  def prepend_flash
    turbo_stream.prepend "flash", partial: "flash"
  end

  SECTION_ICON = {
    capital: "fas fa-landmark",
    accounts: "fas fa-credit-card",
    transactions: "fas fa-receipt",
    categories: "fas fa-swatchbook"
  }.freeze

  # @param section [Symbol] application section name
  # @return [String] HTML code of the link to application section
  # @example
  #   menu_item(:transactions) #=>
  #     <a class="navbar-item is-tab is-active" href="/transactions">
  #       <span class="icon-text">
  #         <span class="icon">
  #           <i class="fas fa-receipt"></i>
  #         </span>
  #         <span>Transactions</span>
  #       </span>
  #     </a>
  def menu_item(section)
    is_active_class = controller_name.eql?(section.to_s) ? "is-active" : nil
    css_class = ["navbar-item is-tab", is_active_class].compact.join(" ")
    path = send(:"#{section}_path")
    text = t(:"menu.#{section}")

    link_to path, class: css_class do
      tag.span(class: "icon-text") do
        icon(SECTION_ICON[section]) + tag.span(text)
      end
    end
  end

  # @param i_class [String] class for the `<i>` element
  # @param options [Hash] additional HTML attributes for the `<span>` wrapper
  # @return [String] HTML code of the icon
  # @example
  #   icon("far fa-trash-can", class: "has-text-danger") #=>
  #     <span class="icon has-text-danger">
  #       <i class="far fa-trash-can"></i>
  #     </span>
  def icon(i_class, options = {})
    options = options.deep_dup
    options[:class] = ["icon", options[:class]].compact.join(" ")
    tag.span(**options) do
      tag.i(class: i_class)
    end
  end

  # @param object [ApplicationRecord] model instance
  # @return [String] relative path for the edit page of the object
  def edit_object_path(object)
    send(:"edit_#{resource_name(object)}_path", object)
  end

  # @param object [ApplicationRecord] model instance
  # @return [String] relative path for the object
  def object_path(object)
    send(:"#{resource_name(object)}_path", object)
  end

  private

  # @param object [ApplicationRecord] model instance
  # @return [String] object resource name
  def resource_name(object)
    object.class.base_class.name.downcase
  end
end
