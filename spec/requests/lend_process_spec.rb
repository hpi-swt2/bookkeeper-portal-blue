require 'rails_helper'

RSpec.describe "Lend Process", type: :request do
  before do
    @group = create(:group)
    @owner = create(:user)
    @item = create(:item, owning_user: @owner, groups_with_lend_permission: [@group])
    @item.waitlist = create(:waitlist_with_item)
    @borrower = create(:user)
    @borrower.to_member_of!(@group)
    @forbidden = create(:user)
    @waiting = create(:user)
    @waiting.to_member_of!(@group)
  end

  describe "POST /request_lend/item" do

    it "with permission changes the item state to reflect the lend request" do
      sign_in @borrower
      expect do
        post request_lend_path(@item)
      end.to(change { @item.reload.lend_status }.from("available").to("pending_lend_request"))
    end

    it "without permission does not change the item state and returns forbidden" do
      sign_in @forbidden
      expect do
        post request_lend_path(@item)
      end.not_to(change { @item.reload.lend_status })
      expect(response).to be_forbidden
    end
  end

  describe "POST /add_to_waitlist/item" do
    before do
      @item.holder = @borrower.id
    end

    it "with permission adds a user to the waitlist" do
      sign_in @waiting
      expect do
        post add_to_waitlist_path(@item)
      end.to change(@item.waitlist.users, :count).by(1)
    end

    it "without permission without permission does not add the user to the waitlist and returns forbidden" do
      sign_in @forbidden
      expect do
        post add_to_waitlist_path(@item)
      end.not_to change(@item.waitlist.users, :count)
      expect(response).to be_forbidden
    end
  end
end
