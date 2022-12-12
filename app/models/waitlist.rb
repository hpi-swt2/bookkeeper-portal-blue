class Waitlist < ApplicationRecord
  belongs_to :item
  has_and_belongs_to_many :users

  def position (user)
    self.users.find_index(user)
  end

  def first_user
    self.users.first
  end

  def add_user (user)
    unless self.users.exists?(user.id) || user.id == self.item.owner
      self.users << user
      self.add_added_to_waitlist_notification(user)
      return true
    end
    return false
  end

  def remove_user (user)
    user_index = self.users.find_index(user) 
    self.users.delete(user)

    self.delete_waitlist_notifications(user)

    unless user_index.nil? || user_index >= self.users.size
      self.users[user_index..-1].each do |temp_user|
        self.delete_waitlist_notifications(temp_user)
        self.add_move_up_on_waitlist_notification(temp_user)
      end
    end
  end

  private

  def delete_waitlist_notifications (user)
    self.delete_added_to_waitlist_notification(user)
    self.delete_moved_up_on_waitlist_notification(user)
  end

  def add_added_to_waitlist_notification (user)
    @notification = AddedToWaitlistNotification.new(user: user, date: Time.now, item: item)
    @notification.save
  end

  def add_move_up_on_waitlist_notification (user)
    @notification = MoveUpOnWaitlistNotification.new(user: user, date: Time.now, item: item)
    @notification.save
  end

  def delete_added_to_waitlist_notification (user)
    @notification = AddedToWaitlistNotification.find_by(item: item, user: user)
    unless @notification.nil?
      @notification.destroy
    end
  end

  def delete_moved_up_on_waitlist_notification (user)
    @notification = MoveUpOnWaitlistNotification.find_by(item: item, user: user)
    unless @notification.nil?
      @notification.destroy
    end
  end
end
