# class of a basic item.
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
end
