# Behavior of STI models that:
#   - always have a concrete (non-abstract) type (i.e. class);
#   - do not change their type.
module FaithfulSTI
  extend ActiveSupport::Concern

  included do
    attr_readonly :type

    after_initialize do
      raise ActiveRecord::SubclassNotFound, "Invalid single-table inheritance type: type must be present" if type.blank?
    end
  end

  class_methods do
    def inherited(subclass)
      super
      subclass.class_eval do
        validates :type, comparison: {equal_to: name, message: "must be #{name}"}
      end
    end
  end
end
