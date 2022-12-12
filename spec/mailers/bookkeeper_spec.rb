require "rails_helper"

RSpec.describe BookkeeperMailer, type: :mailer do
  describe "notification" do
    let(:mail) { described_class.notification }

    it "renders the headers" do
      expect(mail.subject).to eq("Notification")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
