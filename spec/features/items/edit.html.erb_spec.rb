require 'rails_helper'

RSpec.describe "items/show", type: :feature do
  it "preselects the owning user or group" do
    group = create(:group)
    # to check if only 'group' that the user is a member of is shown
    # in the dropdown, a second group is created
    create(:group)
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
