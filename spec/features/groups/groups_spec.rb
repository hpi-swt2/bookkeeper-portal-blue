RSpec.describe "Groups", type: :feature do
  let(:group) { create(:group) }

  it "allows users to create groups" do
    sign_in create(:user)
    visit new_group_path
    fill_in "group_name", with: "Test Group"
    click_button "Add Group"
    expect(page).to have_text("Test Group")
  end

  it "shows the group name" do
    sign_in group.owners.first
    visit group_path(group)
    expect(page).to have_text(group.name)
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

  it "shows demote buttons if current user is owner" do
    sign_in group.owners.first
    visit group_path(group)

    group.owners.each do |owner|
      expect(page).to have_link("Remove owner", href: group_demote_path(group, owner))
    end
  end

  it "shows promote buttons if current user is owner" do
    group.members << create(:max)
    sign_in group.owners.first
    visit group_path(group)

    group.members_without_ownership.each do |member|
      expect(page).to have_link("Make owner", href: group_promote_path(group, member))
    end
  end

  it "does not show demote buttons if current user is not owner" do
    member = create(:max)
    group.members << member
    sign_in member
    visit group_path(group)

    expect(page).not_to have_link("Remove owner")
  end

  it "does not show promote buttons if current user is not owner" do
    member = create(:max)
    group.members << member
    sign_in member
    visit group_path(group)

    expect(page).not_to have_link("Make owner")
  end

  it "promotes members to owners on button click" do
    member = create(:max)
    group.members << member
    sign_in group.owners.first
    visit group_path(group)

    find(:link, "Make owner", href: group_promote_path(group, member)).click

    group.reload

    expect(group.owners).to include(member)
  end

  it "demotes owners to members on button click" do
    owner = create(:max)
    group.owners << owner
    sign_in group.owners.first
    visit group_path(group)

    find(:link, "Remove owner", href: group_demote_path(group, owner)).click

    group.reload

    expect(group.owners).not_to include(owner)
    expect(group.members).to include(owner)
  end
end
