# Uncomment this and change the path if necessary to include your own
# components.
# See https://github.com/heartcombo/simple_form#custom-components to know
# more about custom components.
Rails.root.glob("lib/components/**/*.rb").each { |f| require f }

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  # Wrappers are used by the form builder to generate a
  # complete input. You can remove any component from the
  # wrapper, change the order or even add your own to the
  # stack. The options given below are used to wrap the
  # whole input.
  config.wrappers :default, tag: "div", class: "field" do |b|
    ## Extensions enabled by default
    # Any of these extensions can be disabled for a
    # given input by passing: `f.input EXTENSION_NAME => false`.
    # You can make any of these extensions optional by
    # renaming `b.use` to `b.optional`.

    # Determines whether to use HTML5 (:email, :url, ...)
    # and required attributes
    b.use :html5

    # Calculates placeholders automatically from I18n
    # You can also pass a string as f.input placeholder: "Placeholder"
    b.use :placeholder

    ## Optional extensions
    # They are disabled unless you pass `f.input EXTENSION_NAME => true`
    # to the input. If so, they will retrieve the values from the model
    # if any exists. If you want to enable any of those
    # extensions by default, you can change `b.optional` to `b.use`.

    # Calculates maxlength from length validations for string inputs
    # and/or database column lengths
    b.optional :maxlength

    # Calculate minlength from length validations for string inputs
    b.optional :minlength

    # Calculates pattern from format validations for string inputs
    b.optional :pattern

    # Calculates min and max from length validations for numeric inputs
    b.optional :min_max

    # Calculates readonly automatically from readonly attributes
    b.optional :readonly

    ## Inputs
    b.use :label, class: "label"
    b.wrapper :control, tag: "div", class: "control" do |control|
      control.use :input, class: "input", error_class: "is-danger"
    end
    b.use :error, wrap_with: {tag: "span", class: "help is-danger ml-1"}
    b.use :hint, wrap_with: {tag: "span", class: "help ml-1"}

    ## full_messages_for
    # If you want to display the full error message for the attribute, you can
    # use the component :full_error, like:
    #
    # b.use :full_error, wrap_with: { tag: :span, class: :error }
  end

  config.wrappers :control, tag: "div", class: "control" do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.use :input, class: "input", error_class: "is-danger"
  end

  config.wrappers :horizontal, tag: "div", class: "field is-horizontal" do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :field_label, tag: "div", class: "field-label is-normal" do |field_label|
      field_label.use :label, class: "label"
    end
    b.wrapper :field_body, tag: "div", class: "field-body" do |field_body|
      field_body.wrapper :field, tag: "div", class: "field" do |field|
        field.wrapper :control, tag: "div", class: "control" do |control|
          control.use :input, class: "input", error_class: "is-danger"
        end
        field.use :error, wrap_with: {tag: "span", class: "help is-danger ml-1"}
        field.use :hint, wrap_with: {tag: "span", class: "help ml-1"}
      end
    end
  end

  config.wrappers :boolean, tag: "div", class: "field" do |b|
    b.use :input
  end

  config.wrappers :check_boxes, tag: "div", class: "field" do |b|
    b.use :label, class: "label"
    b.wrapper :control, tag: "div", class: "control" do |control|
      control.wrapper :checkboxes, tag: "div", class: "checkboxes" do |checkbox|
        checkbox.use :input, class: "mr-1"
      end
    end
  end

  config.wrappers :file, tag: "div", class: "field" do |b|
    b.wrapper :file, tag: "div", class: "file" do |file|
      file.wrapper tag: "label", class: "file-label" do |component|
        component.use :input, class: "file-input"
        component.use :file_button
      end
    end
    b.use :error, wrap_with: {tag: "span", class: "help is-danger"}
    b.use :hint, wrap_with: {tag: "span", class: "help"}
  end

  config.wrappers :hidden, tag: false do |b|
    b.use :input
  end

  config.wrappers :select, tag: "div", class: "field", error_class: "is-danger" do |b|
    b.use :html5

    b.use :label, class: "label"
    b.wrapper :control, tag: "div", class: "control" do |control|
      control.wrapper :select, tag: "div", class: "select" do |select|
        select.use :input
      end
    end
    b.use :error, wrap_with: {tag: "span", class: "help is-danger ml-1"}
    b.use :hint, wrap_with: {tag: "span", class: "help ml-1"}
  end

  config.wrappers :select_control, tag: "div", class: "control", error_class: "is-danger" do |b|
    b.use :html5
    b.wrapper :select, tag: "div", class: "select" do |select|
      select.use :input
    end
  end

  config.wrappers :select_horizontal, tag: "div", class: "field is-horizontal", error_class: "is-danger" do |b|
    b.use :html5

    b.wrapper :field_label, tag: "div", class: "field-label is-normal" do |field_label|
      field_label.use :label, class: "label"
    end
    b.wrapper :field_body, tag: "div", class: "field-body" do |field_body|
      field_body.wrapper :field, tag: "div", class: "field" do |field|
        field.wrapper :control, tag: "div", class: "control" do |control|
          control.wrapper :select, tag: "div", class: "select" do |select|
            select.use :input
          end
        end
        field.use :error, wrap_with: {tag: "span", class: "help is-danger ml-1"}
        field.use :hint, wrap_with: {tag: "span", class: "help ml-1"}
      end
    end
  end

  config.wrappers :text, tag: "div", class: "field" do |b|
    b.use :html5
    b.use :label, class: "label"
    b.use :input, class: "textarea", error_class: "is-danger"
    b.use :error, wrap_with: {tag: "span", class: "help is-danger"}
    b.use :hint, wrap_with: {tag: "span", class: "help"}
  end

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :default

  # Define the way to render check boxes / radio buttons with labels.
  # Defaults to :nested for bootstrap config.
  #   inline: input + label
  #   nested: label > input
  config.boolean_style = :nested

  # Default class for buttons
  config.button_class = "button"

  # Method used to tidy up errors. Specify any Rails Array method.
  # :first lists the first message for each field.
  # Use :to_sentence to list all errors for each field.
  # config.error_method = :first
  config.error_method = :to_sentence

  # Default tag used for error notification helper.
  config.error_notification_tag = :div

  # CSS class to add for error notification helper.
  config.error_notification_class = "field notification is-danger is-light"

  # Series of attempts to detect a default label method for collection.
  # config.collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attempts to detect a default value method for collection.
  # config.collection_value_methods = [ :id, :to_s ]

  # You can wrap a collection of radio/check boxes in a pre-defined tag, defaulting to none.
  # config.collection_wrapper_tag = nil

  # You can define the class to use on all collection wrappers. Defaulting to none.
  # config.collection_wrapper_class = nil

  # You can wrap each item in a collection of radio/check boxes with a tag,
  # defaulting to :span.
  # config.item_wrapper_tag = :span
  config.item_wrapper_tag = nil

  # You can define a class to use in all item wrappers. Defaulting to none.
  # config.item_wrapper_class = nil

  # How the label text should be generated altogether with the required text.
  config.label_text = ->(label, required, _explicit_label) { "#{label} #{required}" }

  # You can define the class to use on all labels. Default is nil.
  # config.label_class = nil

  # You can define the default class to be used on forms. Can be overridden
  # with `html: { :class }`. Defaulting to none.
  # config.default_form_class = nil

  # You can define which elements should obtain additional classes
  # config.generate_additional_classes_for = [:wrapper, :label, :input]
  config.generate_additional_classes_for = []

  # Whether attributes are required by default (or not). Default is true.
  # config.required_by_default = true

  # Tell browsers whether to use the native HTML5 validations (novalidate form option).
  # These validations are enabled in SimpleForm's internal config but disabled by default
  # in this configuration, which is recommended due to some quirks from different browsers.
  # To stop SimpleForm from generating the novalidate option, enabling the HTML5 validations,
  # change this configuration to true.
  config.browser_validations = true

  # Custom mappings for input types. This should be a hash containing a regexp
  # to match as key, and the input type that will be used when the field name
  # matches the regexp as value.
  # config.input_mappings = { /count/ => :integer }

  # Custom wrappers for input types. This should be a hash containing an input
  # type as key and the wrapper that will be used for all inputs with specified type.
  # config.wrapper_mappings = { string: :prepend }
  config.wrapper_mappings = {
    boolean: :boolean,
    check_boxes: :check_boxes,
    file: :file,
    hidden: :hidden,
    text: :text
  }

  # Namespaces where SimpleForm should look for custom input classes that
  # override default inputs.
  # config.custom_inputs_namespaces << "CustomInputs"

  # Default priority for time_zone inputs.
  # config.time_zone_priority = nil

  # Default priority for country inputs.
  # config.country_priority = nil

  # When false, do not use translations for labels.
  # config.translate_labels = true

  # Automatically discover new inputs in Rails' autoload path.
  # config.inputs_discovery = true

  # Cache SimpleForm inputs discovery
  # config.cache_discovery = !Rails.env.development?

  # Default class for inputs
  # config.input_class = nil

  # Define the default class of the input wrapper of the boolean input.
  config.boolean_label_class = "checkbox"

  # Defines if the default input wrapper class should be included in radio
  # collection wrappers.
  # config.include_default_input_wrapper_class = true

  # Defines which i18n scope will be used in Simple Form.
  # config.i18n_scope = "simple_form"

  # Defines validation classes to the input_field. By default it's nil.
  # config.input_field_valid_class = "is-valid"
  # config.input_field_error_class = "is-invalid"
end
