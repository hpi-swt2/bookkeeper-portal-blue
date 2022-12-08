RSpec.describe "Groups", type: :feature do
  let(:group) { create(:group) }

  it "shows the group name" do
    sign_in group.owners.first
    visit group_path(group)
    expect(page).to have_text("TestGroup")
  end

  it "shows the owners" do
    sign_in group.owners.first
    visit group_path(group)
    expect(find_by_id('group-owners')).to have_text(group.owners.first.name)
  end

  it "shows the members" do
    user = create(:user)
    group.members.append(user)
    sign_in user
    visit group_path(group)
    expect(find_by_id('group-members')).to have_text(user.name)
  end

  it "shows the owners not in the members list" do
    sign_in group.owners.first
    visit group_path(group)
    expect(find_by_id('group-members')).not_to have_text(group.owners.first.name)
  end
end
