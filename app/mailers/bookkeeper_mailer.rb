class BookkeeperMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.bookkeeper_mailer.notification.subject
  #
  def notification
    @greeting = "Hi"

    mail to: "youremail@gmail.com"
  end
end
