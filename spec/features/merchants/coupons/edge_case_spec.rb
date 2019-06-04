require 'rails_helper'


describe "As a user checking out" do
  describe "If a coupons dollar off amount exceeds the total cost of everything in the cart, the price will be 0.00" do
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
    end
    it "The discounted total should not display a negative value" do

      expect(current_path).to eq(cart_path)

      fill_in 'Name', with: @coupon.name
      click_on "Add Coupon"

      expect(page).to have_content("#{@coupon.name} has been added to your order")

      expect(page).to have_content("Discounted Total: $0.00")
    end

    it "During a session, a user can continue to enter coupons until they check out but then their decision is final" do

      expect(current_path).to eq(cart_path)

      fill_in 'Name', with: @coupon_2.name
      click_on "Add Coupon"

      expect(page).to have_content("#{@coupon_2.name} has been added to your order")

      expect(page).to have_content("Discounted Total: $5.00")

      fill_in "Name", with: @coupon_3.name
      click_on "Add Coupon"

      expect(page).to have_content("#{@coupon_3.name} has been added to your order")

      expect(page).to have_content("Discounted Total: $4.00")
    end

    it "If a user adds a coupon code, they can continue shopping. The coupon code is still remembered when returning to the cart page" do


      fill_in "Name", with: @coupon_3.name
      click_on "Add Coupon"

      expect(page).to have_content("#{@coupon_3.name} has been added to your order")

      expect(page).to have_content("Discounted Total: $4.00")

      visit items_path

      within("#item-#{@item_1.id}") do
        click_on "Add to Cart"
        click_on "Add to Cart"
        click_on "Add to Cart"
        click_on "Add to Cart"
      end

      expect(current_path).to eq(cart_path)

      expect(page).to have_content("Discounted Total: $12.00")


      visit items_path

      within("#item-#{@item_4.id}") do
        click_on "Add to Cart"
        click_on "Add to Cart"
      end


      expect(current_path).to eq(cart_path)

      expect(page).to have_content("Discounted Total: $19.00")

      fill_in "Name", with: @coupon_4.name
      click_on "Add Coupon"

      expect(page).to have_content("#{@coupon_4.name} has been added to your order")
      expect(page).to have_content("Discounted Total: $17.00")
    end

    it "if a user has a coupon that exceeds the value of items bought by that merchant but still has other items, you will see the total values of the other items" do

      visit items_path

      within("#item-#{@item_4.id}") do
        click_on "Add to Cart"
        click_on "Add to Cart"
        click_on "Add to Cart"
        click_on "Add to Cart"
      end

      expect(current_path).to eq(cart_path)

      fill_in "Name", with: @coupon_5.name
      click_on "Add Coupon"

      expect(page).to have_content("#{@coupon_5.name} has been added to your order")

      expect(page).to have_content("Discounted Total: $8.00")
    end
  end
end
