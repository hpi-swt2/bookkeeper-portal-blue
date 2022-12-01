require "rails_helper"

RSpec.describe "Landing Page", type: :feature do

  let(:user) { build(:user) }

  it "redirects to login without user signed in" do
    visit root_path
    expect(current_path).to eq(new_user_session_path)
  end

  it "redirects to dashboard with user signed in" do
    @user = create(:user)
    sign_in @user
    visit root_path
    expect(current_path).to eq(dashboard_path)
  end
end
