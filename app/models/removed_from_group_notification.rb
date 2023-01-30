# class of a removed from group notification
class RemovedFromGroupNotification < ApplicationRecord
  acts_as :notification

  validates :receiver, presence: true
  validates :date, presence: true
  validates :group_name, presence: true

  after_create :send_mail

  def title
    I18n.t "views.notifications.removed_from_group.title"
  end

  def description
    I18n.t "views.notifications.removed_from_group.description", group_name: group_name
  end
end
