require 'rails_helper'

describe "Users can use coupons when checking out" do
  before :each do
    @merchant = create(:merchant)
      @item_1 = create(:item, price: 2.00, user: @merchant)
      @item_2 = create(:item, price: 3.00, user: @merchant)
      @item_3 = create(:item, price: 3.00, user: @merchant)

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
  describe "When a registered reaches the cart show page they can enter the coupon name and see the discounted total on the cart show page" do
    it "After adding items to the cart by a merchant, I can enter a coupon code/name and see the discounted total" do

      expect(current_path).to eq(cart_path)

      fill_in 'Name', with: @coupon.name
      click_on "Add Coupon"

      expect(page).to have_content("#{@coupon.name} has been added to your order")

      expect(page).to have_content("Discounted Total: $4.00")
    end

    it "Discount is only applied to that merchants items" do
      merchant_2 = create(:merchant)
        item_4 = create(:item, price: 3.00, user: merchant_2)

      merchant_3 = create(:merchant)
        item_5 = create(:item, price: 5.00, user: merchant_3)

        visit items_path

        within("#item-#{item_4.id}") do
          click_on "Add to Cart"
          click_on "Add to Cart"
          click_on "Add to Cart"
        end

        visit items_path

        within("#item-#{item_5.id}") do
          click_on "Add to Cart"
          click_on "Add to Cart"
          click_on "Add to Cart"
        end

      fill_in 'Name', with: @coupon.name
      click_on "Add Coupon"

      expect(page).to have_content("#{@coupon.name} has been added to your order")

      expect(page).to have_content("Discounted Total: $28.00")
    end
  end
end
