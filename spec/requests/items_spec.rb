require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/items", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Item. As you add validations to Item, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      name: "Test",
      location: "Test",
      category: "Test",
      description: "Test",
      owning_user: create(:user),
      groups_with_lend_permission: [create(:group)],
      groups_with_see_permission: [create(:group)]
    }
  end

  let(:valid_request_attributes) do
    {
      name: "Test",
      location: "Test",
      category: "Test",
      description: "Test",
      owner_id: "user:#{create(:user).id}",
      lend_group_ids: [create(:group).id],
      see_group_ids: [create(:group).id]
    }
  end

  let(:valid_request_attributes_group) do
    {
      name: "Test",
      location: "Test",
      category: "Test",
      description: "Test",
      owner_id: "group:#{create(:group).id}",
      lend_group_ids: [create(:group).id],
      see_group_ids: [create(:group).id]
    }
  end

  let(:invalid_attributes) do
    { name: "Test", category: "Test", description: "Test", price_ct: "NotAnInt", lend_group_ids: [], see_group_ids: [] }
  end

  describe "GET /index" do
    it "renders a successful response" do
      Item.create! valid_attributes
      get items_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      item = create(:item)
      item.waitlist = create(:waitlist_with_item)
      get item_url(item)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_item_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      item = Item.create! valid_attributes
      get edit_item_url(item)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Item" do
        expect do
          post items_url, params: { item: valid_request_attributes }
        end.to change(Item, :count).by(1)
      end

      it "creates a new item owned by a group" do
        expect do
          post items_url, params: { item: valid_request_attributes_group }
        end.to change(Item, :count).by(1)
      end

      it "redirects to the created item" do
        post items_url, params: { item: valid_request_attributes }
        expect(response).to redirect_to(item_url(Item.last, locale: RSpec.configuration.locale))
      end

      it "creates an audit event" do
        sign_in create(:user)
        post items_url, params: { item: valid_request_attributes }
        expect(AuditEvent.where(event_type: "create_item").count).to be(1)
      end

      it "added groups with see and lend permissions" do
        post items_url, params: { item: valid_request_attributes }

        expect(Item.last.groups_with_see_permission.map(&:id)).to match_array(
          valid_request_attributes[:see_group_ids] + valid_request_attributes[:lend_group_ids]
        )
        expect(Item.last.groups_with_lend_permission.map(&:id)).to match_array valid_request_attributes[:lend_group_ids]
      end
    end

    context "with invalid parameters" do
      it "does not create a new Item" do
        expect do
          post items_url, params: { item: invalid_attributes }
        end.not_to change(Item, :count)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        {
          description: "NewDescription",
          location: "NewLocation",
          see_group_ids: [ create(:group).id ],
          lend_group_ids: [ create(:group).id ]
        }
      end

      it "updates the requested item" do
        item = Item.create! valid_attributes
        patch item_url(item), params: { item: new_attributes }
        item.reload
        expect(item.description).to eq("NewDescription")
        expect(item.location).to eq("NewLocation")
      end

      it "redirects to the item" do
        item = Item.create! valid_attributes
        patch item_url(item), params: { item: new_attributes }
        item.reload
        expect(response).to redirect_to(item_url(item, locale: RSpec.configuration.locale))
      end

      it "updates the groups with see and lend permissions accordingly" do
        item = Item.create! valid_attributes
        patch item_url(item), params: { item: new_attributes }
        item.reload

        expect(Item.last.groups_with_see_permission.map(&:id)).to match_array(
          new_attributes[:see_group_ids] + new_attributes[:lend_group_ids]
        )
        expect(Item.last.groups_with_lend_permission.map(&:id)).to match_array new_attributes[:lend_group_ids]
      end
    end

    context "with invalid parameters" do
      let(:new_attributes) do
        { description: 0, price_ct: "NotAnInteger" }
      end

      it "does not update the requested item" do
        item = Item.create! valid_attributes
        patch item_url(item), params: { item: new_attributes }
        item.reload
        expect(item.description).not_to eq(0)
        expect(item.price_ct).not_to eq("NotAnInteger")
      end

    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested item" do
      item = Item.create! valid_attributes
      expect do
        delete item_url(item)
      end.to change(Item, :count).by(-1)
    end

    it "redirects to the items list" do
      item = Item.create! valid_attributes
      delete item_url(item)
      expect(response).to redirect_to(items_url(locale: RSpec.configuration.locale))
    end
  end
end
