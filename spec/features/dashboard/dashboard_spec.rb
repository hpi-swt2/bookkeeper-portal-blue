require "rails_helper"

RSpec.describe "Dashboard", type: :feature do

  let(:user) { build(:user) }

  it "renders without user signed in" do
    visit dashboard_path
    expect(page).to have_content("Du bist nicht angemeldet.")
  end

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

  it "shows message when nothing is offered" do
    @user = create(:user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content("Du bietest bisher nichts an.")
  end

  it "shows offered item" do
    @user = create(:user)
    item = create(:item, owner: @user.id)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
  end

  it "shows wishlist" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content(/Wunschliste/i)
  end

  it "shows wishlist item" do
    @user = create(:user)
    item = create(:item)
    @user.wishlist << (item)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content(item.name)
  end

  it "shows message when wishlist is empty" do
    @user = create(:user)
    sign_in @user
    visit dashboard_path
    expect(page).to have_content("You don't have any items saved at the moment.")
    page.driver.header 'Accept-language', 'de-DE'
    visit dashboard_path
    expect(page).to have_content("Du hast zurzeit keine Artikel gespeichert.")
  end
end
