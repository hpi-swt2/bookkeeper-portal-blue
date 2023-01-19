require "rails_helper"

RSpec.describe "Waitlist View", type: :feature do

  let(:owner) { create(:user) }
  let(:user) { create(:user) }
  let(:borrower) { create(:user) }

  let(:item_lent) do
    item_lent = create(:lent, owning_user: owner, holder: borrower.id)
    item_lent.waitlist = create(:waitlist_with_item)
    item_lent.waitlist.item = item_lent
  end

  it "shows item you are waiting for" do
    sign_in user
    visit item_path(item_lent)
    find(:button, "Enter Waitlist").click
    visit dashboard_path
    expect(page).to have_content(item_lent.name)
  end

  it "shows message when you are not waiting for any items" do
    sign_in user
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.waitlist.nowhere_on_waitlists')
  end

  it "shows the position in the waitlist as a tag" do
    sign_in user
    visit item_path(item_lent)
    expect(page).to have_content I18n.t('views.show_item.users_waiting', amount: 2)
    find(:button, "Enter Waitlist").click
    visit dashboard_path
    expect(page).to have_content I18n.t('views.dashboard.waitlist.position', position: 3)
  end
end
