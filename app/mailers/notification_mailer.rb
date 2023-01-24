class NotificationMailer < ApplicationMailer
  def notification(notification)
    @title = notification.title
    @description = notification.description

    mail(to: notification.receiver.email,
         subject: I18n.t("notification_mailer.notification.subject", notification_name: @title))
  end
end
