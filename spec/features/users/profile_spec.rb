RSpec.describe "Profile", type: :feature do

  let(:user) { build(:max) }
  let(:group) { build(:group) }

  it "shows the user name" do
    sign_in user
    visit profile_path
    expect(page).to have_text("Max Mustermann")
    expect(page).to have_text("max.mustermann@student.hpi.uni-potsdam.de")
  end

  it "shows the user email" do
    sign_in user
    visit profile_path
    expect(page).to have_text("max.mustermann@student.hpi.uni-potsdam.de")
  end

  it "has an edit profile button" do
    sign_in user
    visit profile_path
    expect(page).to have_link 'Profil bearbeiten', href: edit_user_registration_path
  end

  it "displays the user's groups when member" do
    user.groups.append(group)
    user.save
    sign_in user
    visit profile_path
    expect(page).to have_text("TestGroup")
  end

  it "displays the user's owned groups" do
    user.owned_groups.append(group)
    user.save
    sign_in user
    visit profile_path
    expect(page).to have_text("TestGroup")
  end

  it "displays a message when in no groups" do
    sign_in user
    visit profile_path
    expect(page).to have_text("Not member of any group")
  end
end
