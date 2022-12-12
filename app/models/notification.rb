# This actable (i.e. abstract) class is designed to be the superclass of all
# specific types of notifications. It is responsible for some very basic functionality
# and delegating missing methods to the specific notification subclass.
class Notification < ApplicationRecord
  actable

  belongs_to :user

  def custom_partial
    specific.class.name.underscore
  end

  # delegate methods from the "subclasses" (which aren't really subclasses)
  # to the specific instances
  def method_missing(method, *args, &block)
    if specific.self_respond_to?(method)
      specific.send(method, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    false
  end
end
