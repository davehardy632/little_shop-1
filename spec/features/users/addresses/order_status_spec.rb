require 'rails_helper'


describe "A user cannot delete an address if it has been used in a completed order" do
  before :each do
    @user = create(:user)
    login_as(@user)

    @address_1 = @user.addresses.create(address: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Work")
    @address_2 = @user.addresses.create(address: "1421 east 23rd ave", city: "Austin", state: "TX", zip: "80221",  nickname: "Home")
    @address_3 = @user.addresses.create(address: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Other")

    @completed_order = Order.create!(status: "shipped", user: @user, address: @address_1)

    @item_1 = create(:item)
    @item_2 = create(:item)
    @item_3 = create(:item)

    @oi_1 = create(:fulfilled_order_item, item: @item_1, order: @completed_order)
    @oi_1 = create(:fulfilled_order_item, item: @item_2, order: @completed_order)
    @oi_1 = create(:fulfilled_order_item, item: @item_3, order: @completed_order)


  end

  it "If a user wants to delete an address associated with a completed order, There is no delete button on the addresses index page" do

    visit profile_addresses_path

    within("#address-#{@address_1.id}") do
      expect(page).to_not have_link("Delete Address")
      expect(page).to_not have_link("Edit Address")
    end
  end
end
