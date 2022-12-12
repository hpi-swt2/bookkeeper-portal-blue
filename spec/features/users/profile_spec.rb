RSpec.describe "Profile", type: :feature do

  let(:user) { build(:max) }
  let(:group) { build(:group) }

  it "shows the user name" do
    sign_in user
    visit profile_path
    expect(page).to have_text(user.name)
    expect(page).to have_text(user.email)
  end

  it "shows roles" do
    sign_in user
    visit profile_path
    expect(page).to have_content I18n.t('views.profile.roles')
  end

  it "shows email address" do
    sign_in user
    visit profile_path
    expect(page).to have_content I18n.t('views.profile.email')
  end

  it "shows the user email" do
    sign_in user
    visit profile_path
    expect(page).to have_text(user.email)
  end

  it "shows groups" do
    sign_in user
    visit profile_path
    expect(page).to have_content I18n.t('views.profile.groups')
  end

  it "has an edit profile button" do
    sign_in user
    visit profile_path
    expect(page).to have_link 'Profil bearbeiten', href: edit_user_registration_path
  end

  it "has a create group button" do
    sign_in user
    visit profile_path
    expect(page).to have_link 'Add Group', href: new_group_path
  end

  it "displays the user's groups when member" do
    user.groups.append(group)
    user.save
    sign_in user
    visit profile_path
    expect(page).to have_text(group.name)
  end

  it "displays the user's owned groups" do
    user.owned_groups.append(group)
    user.save
    sign_in user
    visit profile_path
    expect(page).to have_text(group.name)
  end

  it "displays a message when in no groups" do
    sign_in user
    visit profile_path
    expect(page).to have_text("Not member of any group")
  end
end
