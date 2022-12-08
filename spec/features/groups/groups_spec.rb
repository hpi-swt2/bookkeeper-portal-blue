RSpec.describe "Groups", type: :feature do
  let(:group) { create(:group) }

  it "allows users to create groups" do
    sign_in create(:user)
    visit new_group_path
    fill_in "group_name", with: "Test Group"
    click_button "Create Group"
    expect(page).to have_text("Test Group")
    # Expected to fail since view page is part of another PR
  end
end