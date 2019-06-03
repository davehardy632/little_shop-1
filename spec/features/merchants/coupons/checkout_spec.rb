require 'rails_helper'

describe "Users can use coupons when checking out" do
  before :each do
    @merchant = create(:merchant)
      @item_1 = create(:item, price: 2.00)
      @item_2 = create(:item, price: 3.00)
      @item_3 = create(:item, price: 3.00)

      @coupon = @merchant.coupons.create(name: "Coupon 1", discount: 2.00)

    @user = create(:user)
    login_as(@user)
    @address = @user.addresses.create(address: "123 west 32nd ave", city: "Denver", state: "CO", zip: "80102")
    visit items_path

    within("#item-#{@item_1.id}") do
      click_on "Add to Cart"
      click_on "Add to Cart"
      click_on "Add to Cart"
    end

  end
  describe "When a registered user checks out, they can enter the coupon name and see the discounted total on the cart show page" do
    it "After adding items to the cart by a merchant, I can enter a coupon code/name and see the discounted total" do

      expect(current_path).to eq(cart_path)

      fill_in 'Name', with: @coupon.name
      click_on "Add Coupon"

      expect(page).to have_content("#{@coupon_1.name} has been added to your order")

      expect(page).to have_content("Discounted Total: $4.00")
    end
  end
end
