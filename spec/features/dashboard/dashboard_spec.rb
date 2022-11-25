require "rails_helper"

RSpec.describe "Dashboard", type: :feature do

  let(:user) { build(:user) }

  it "shows the user name" do
    @user = create(:user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content("User1")
  end

  it "shows unread messages" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content(/ungelesene Nachrichten/i)
  end

  it "shows borrowed items" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content(/ausgeliehen/i)
  end

  it "shows offered messages" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content(/angebotene Artikel/i)
  end

  it "shows wishlist" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content(/Wunschliste/i)
  end
end
