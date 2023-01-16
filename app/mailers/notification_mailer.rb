class NotificationMailer < ApplicationMailer

  def notification(notification)
    @greeting = "Hi"

    mail(to: notification.receiver.email,
         subject: I18n.t("notification_mailer.notification.subject", notification_name: notification.title))
  end
end
