require 'rails_helper'

describe "Coupons can be used by multiple users but only once per user" do
  before :each do
    @merchant = create(:merchant)
      @item_1 = create(:item, price: 3.00, user: @merchant, inventory: 20)
        @coupon = @merchant.coupons.create!(name: "Coupon", discount: 5.00)

    @user = create(:user)
      @address = @user.addresses.create!(address: "1233 hedge lane", city: "Denver", state: "CO", zip: "80226")
    @user_2 = create(:user)
      @address_2 = @user_2.addresses.create!(address: "1233 hedge lane", city: "Denver", state: "CO", zip: "80226")
  end

  it "User can only use a coupon once" do

    login_as(@user)

    visit items_path

    within("#item-#{@item_1.id}") do
      click_on "Add to Cart"
      click_on "Add to Cart"
      click_on "Add to Cart"
      click_on "Add to Cart"
    end

    expect(current_path).to eq(cart_path)

    fill_in 'Name', with: @coupon.name
    click_on "Add Coupon"

    click_on "Check Out With Address: home"


    expect(current_path).to eq(profile_orders_path)

    visit items_path

    within("#item-#{@item_1.id}") do
      click_on "Add to Cart"
      click_on "Add to Cart"
      click_on "Add to Cart"
      click_on "Add to Cart"
    end

    fill_in 'Name', with: @coupon.name
    click_on "Add Coupon"

    expect(current_path).to eq(cart_path)
    expect(page).to have_content("Coupons cannot be used twice, you have already used this coupon")
    expect(page).to have_content("Total: $12.00")
  end
end
