require 'rails_helper'

describe "If a users order is still pending, they can change their shipping address" do
  before :each do
    @user = create(:user)
    login_as(@user)

    @address_1 = @user.addresses.create(address: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Work")
    @address_2 = @user.addresses.create(address: "1421 east 23rd ave", city: "Austin", state: "TX", zip: "80221",  nickname: "Home")
    @address_3 = @user.addresses.create(address: "4434 north 17th st", city: "St. Louis", state: "MI", zip: "32331",  nickname: "Other")

    @pending_order = Order.create!(status: "pending", user: @user, address: @address_1)
    @packaged_order = Order.create!(status: "packaged", user: @user, address: @address_2)
    @shipped_order = Order.create!(status: "shipped", user: @user, address: @address_3)
    @cancelled_order = Order.create!(status: "cancelled", user: @user, address: @address_1)

    @item_1 = create(:item)
    @item_2 = create(:item)

    @oi_1 = create(:fulfilled_order_item, item: @item_1, order: @pending_order)
    @oi_2 = create(:fulfilled_order_item, item: @item_2, order: @packaged_order)
    @oi_3 = create(:fulfilled_order_item, item: @item_1, order: @shipped_order)
    @oi_4 = create(:fulfilled_order_item, item: @item_2, order: @cancelled_order)
  end

  it "User can change shipping address on pending order from orders index page" do

    visit profile_orders_path

    within("#order-#{@pending_order.id}")  do
      expect(page).to have_button("Change Shipping to: #{@address_2.nickname} address at #{@address_2.address}")
      expect(page).to have_button("Change Shipping to: #{@address_3.nickname} address at #{@address_3.address}")
    end

    within("#order-#{@packaged_order.id}")  do
      expect(page).to_not have_button("Change Shipping to: #{@address_1.nickname} address at #{@address_1.address}")
      expect(page).to_not have_button("Change Shipping to: #{@address_3.nickname} address at #{@address_3.address}")
    end

    within("#order-#{@shipped_order.id}")  do
      expect(page).to_not have_button("Change Shipping to: #{@address_2.nickname} address at #{@address_2.address}")
      expect(page).to_not have_button("Change Shipping to: #{@address_1.nickname} address at #{@address_1.address}")
    end

    within("#order-#{@cancelled_order.id}")  do
      expect(page).to_not have_button("Change Shipping to: #{@address_2.nickname} address at #{@address_2.address}")
      expect(page).to_not have_button("Change Shipping to: #{@address_3.nickname} address at #{@address_3.address}")
    end
  end
end
