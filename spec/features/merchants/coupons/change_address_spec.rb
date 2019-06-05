require 'rails_helper'

describe "User can change shipping address if the order is still pending" do
  before :each do
    @merchant = create(:merchant)
      @item = create(:item, user: @merchant)
      @item = create(:item, user: @merchant)
      @item = create(:item, user: @merchant)
        @coupon = @merchant.coupons.create!(name: "Coupon", discount: 5.00)

    @user = create(:user)
      @address_1 = @user.addresses.create!(address: "1266 east 12th ave", city: "Denver", state: "CO", zip: "11242", nickname: "work")
      @address_2 = @user.addresses.create!(address: "1221 north 12th ave", city: "Denver", state: "CO", zip: "11242", nickname: "vacation")
      @address_3 = @user.addresses.create!(address: "1221 west 12th ave", city: "Denver", state: "CO", zip: "11242")

      @order = Order.create!(user: @user, address: @address_1, coupon: @coupon, status: 'pending')

      login_as(@user)

      visit profile_orders_path
  end
  it "After checking out a user can click 'Change Shipping to other address'" do

    within("#order-#{@order.id}") do
      click_on "Change Shipping to: home address at 1221 west 12th ave"
    end

    expect(@order.address).to eq(@address_3)
  end
end
