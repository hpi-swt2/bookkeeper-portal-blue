require "rails_helper"

describe "Return Request Notifications", type: :feature do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }

before do
    sign_in user
    FactoryBot.reload
    @notification = FactoryBot.build(:return_request_notification, user: user)
    @notification.save    
end

it "shows an accept and decline button" do
    visit notifications_path
    expect(page).to have_button('Accept')
    expect(page).to have_button('Decline')
end

end




