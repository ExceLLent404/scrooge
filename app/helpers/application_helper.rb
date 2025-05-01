module ApplicationHelper
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
  #     <a class="navbar-item is-tab" href="/transactions">
  #       <span class="icon-text">
  #         <span class="icon">
  #           <i class="fas fa-receipt"></i>
  #         </span>
  #         <span>Transactions</span>
  #       </span>
  #     </a>
  def menu_item(section)
    path = send(:"#{section}_path")
    text = t(:"menu.#{section}")

    link_to path, class: "navbar-item is-tab" do
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
end
