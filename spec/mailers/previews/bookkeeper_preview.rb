# Preview all emails at http://localhost:3000/rails/mailers/bookkeeper
class BookkeeperPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/bookkeeper/notification
  def notification
    BookkeeperMailer.notification
  end

end
