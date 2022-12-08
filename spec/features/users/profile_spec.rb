RSpec.describe "Profile", type: :feature do

  let(:user) { build(:max) }

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

  it "has a create group button" do
    sign_in user
    visit profile_path
    expect(page).to have_link 'Add Group', href: new_group_path
  end
end
