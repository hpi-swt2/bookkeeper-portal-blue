require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "notification" do
    before do
      @notification = build(:lend_request_notification)
    end

    let(:mail) { described_class.notification(@notification) }

    it "renders the headers" do
      expect(mail.subject).to eq("Lend Request")
      expect(mail.to).to eq([@notification.receiver.email])
      expect(mail.from).to eq(["bookkeeperblue.notification@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(@notification.description)
    end
  end

end
