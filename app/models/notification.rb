# Super-class to hold information about all Notifications
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
    super(method, include_private)
  end

end
