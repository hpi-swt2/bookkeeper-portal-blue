require 'rails_helper'

RSpec.describe "Groups", type: :request do
  describe "POST /groups/id/add_member" do
    let(:group) { create(:group) }
    let(:owner) { group.owners.first }
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it "as owning" do
      sign_in owner
      expect do
        post "/groups/#{group.id}/add_member", params: { user_id: user.id }
      end.to change(group.members, :count).by(1)
    end

    it "as member" do
      sign_in user
      expect do
        post "/groups/#{group.id}/add_member", params: { user_id: other_user.id }
      end.not_to change(group.members, :count)
      expect(response).to be_unauthorized
    end

  end

end
