require "rails_helper"

RSpec.describe "Waitlist View", type: :feature do

  let(:user) { create(:user) }

  let(:item_lent) do
    item_lent = create(:item)
    item_lent.waitlist = create(:empty_waitlist)
    item_lent.waitlist.item = item_lent
  end

  it "shows item you are waiting for" do
    sign_in user
    item_lent.waitlist.add_user(user)
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
    item_lent.waitlist.add_user(user)
    visit dashboard_path
    expect(page).to have_content I18n.t 'views.dashboard.waitlist.position',
                                        position: (item_lent.waitlist.position(user) + 1)
  end
end
