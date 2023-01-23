require 'rails_helper'

RSpec.describe "items/show", type: :feature do
  it "should preselect the owning user or group" do
    group = create(:group)
    group2 = create(:group)
    member = group.owners[0]
    group_item = create(:item, owning_group: group)
    user_item = create(:item, owning_user: member)
    sign_in member
    visit edit_item_url(group_item)
    expect(page).to have_select "item_owner_id", options: [member.email, group.name], selected: group.name
    visit edit_item_url(user_item)
    expect(page).to have_select "item_owner_id", options: [member.email, group.name], selected: member.email
  end
end