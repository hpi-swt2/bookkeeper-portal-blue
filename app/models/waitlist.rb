# Waitlist model for handling adding and removing of users from items waitlist and corresponding side effects.
class Waitlist < ApplicationRecord
  belongs_to :item
  has_and_belongs_to_many :users

  def position(user)
    users.find_index(user)
  end

  def first_user
    users.first
  end

  def add_user(user)
    unless users.exists?(user.id) || user.id == item.owner
      users << user
      add_added_to_waitlist_notification(user)
      return true
    end
    false
  end

  def remove_user(user)
    user_index = users.find_index(user)
    users.delete(user)

    delete_waitlist_notifications(user)

    return if user_index.nil? || user_index >= users.size

    users[user_index..].each do |temp_user|
      delete_waitlist_notifications(temp_user)
      add_move_up_on_waitlist_notification(temp_user)
    end
  end

  private

  def delete_waitlist_notifications(user)
    delete_added_to_waitlist_notification(user)
    delete_moved_up_on_waitlist_notification(user)
  end

  def add_added_to_waitlist_notification(user)
    @notification = AddedToWaitlistNotification.new(receiver: user, date: Time.zone.now, item: item)
    @notification.save
  end

  def add_move_up_on_waitlist_notification(user)
    @notification = MoveUpOnWaitlistNotification.new(receiver: user, date: Time.zone.now, item: item)
    @notification.save
  end

  def delete_added_to_waitlist_notification(user)
    @notification = AddedToWaitlistNotification.find_by(item: item, receiver: user)
    return if @notification.nil?

    @notification.destroy
  end

  def delete_moved_up_on_waitlist_notification(user)
    @notification = MoveUpOnWaitlistNotification.find_by(item: item, receiver: user)
    return if @notification.nil?

    @notification.destroy
  end
end
