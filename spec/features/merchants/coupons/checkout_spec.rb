require 'rails_helper'

describe "User checkout with a coupon" do
  before :each do
    @merchant = create(:merchant)
      @item_1 = create(:item, price: 2.00, user: @merchant, inventory: 22)
      @item_2 = create(:item, price: 3.00, user: @merchant)
      @item_3 = create(:item, price: 3.00, user: @merchant)

    @merchant_2 = create(:merchant)
      @item_4 = create(:item, price: 3.50, user: @merchant_2, inventory: 10)

      @coupon = @merchant.coupons.create(name: "Coupon 1", discount: 10.00)
      @coupon_2 = @merchant.coupons.create(name: "Coupon 2", discount: 3.00)
      @coupon_3 = @merchant.coupons.create(name: "Coupon 3", discount: 4.00)
      @coupon_4 = @merchant_2.coupons.create(name: "Coupon 4", discount: 6.00)
      @coupon_5 = @merchant_2.coupons.create(name: "Coupon 5", discount: 15.00)

    @user = create(:user)
    login_as(@user)
    @address = @user.addresses.create(address: "123 west 32nd ave", city: "Denver", state: "CO", zip: "80102")

    visit items_path

    within("#item-#{@item_1.id}") do
      click_on "Add to Cart"
      click_on "Add to Cart"
      click_on "Add to Cart"
      click_on "Add to Cart"
    end

    visit items_path

    within("#item-#{@item_2.id}") do
      click_on "Add to Cart"
      click_on "Add to Cart"
    end
  end

  describe "When a user adds a coupon to their order, and checks out, the discounted total is applied" do
    it "the order index page displays which coupon was used" do

      expect(current_path).to eq(cart_path)

      fill_in 'Name', with: @coupon.name
      click_on "Add Coupon"

      expect(page).to have_content("#{@coupon.name} has been added to your order")

      expect(page).to have_content("Discounted Total: $4.00")

      click_on "Check Out With Address: home"

      order = Order.last

      expect(current_path).to eq(profile_orders_path)

      within("#order-#{order.id}") do
        expect(page).to have_content("Total Cost: 4.0")
        expect(page).to have_content("Coupon Used: #{@coupon.name}")
      end

      visit profile_order_path(order)

      within("#order-#{order.id}") do
        expect(page).to have_content("Coupon Used: #{@coupon.name}")
        expect(page).to have_content("Total Cost: 4.0")
      end
    end
  end
end
