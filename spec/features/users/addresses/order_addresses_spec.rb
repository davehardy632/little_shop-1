require 'rails_helper'

describe "When a user checks out, they can choose which address to ship to on the page" do
  before :each do
    @user = create(:user)
    login_as(@user)

    @item_1 = create(:item)
    @item_2 = create(:item)
    @item_3 = create(:item)

    @address_1 = @user.addresses.create(address: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Work")
    @address_2 = @user.addresses.create(address: "1421 east 23rd ave", city: "Austin", state: "TX", zip: "80221",  nickname: "Home")
    @address_3 = @user.addresses.create(address: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Other")

    visit items_path

      within("#item-#{@item_2.id}") do
        click_on "Add to Cart"
        click_on "Add to Cart"
        click_on "Add to Cart"
      end
    end

    it "At checkout a user sees all addresses to send an order to" do


      expect(current_path).to eq(cart_path)

      expect(page).to have_button("Check Out With Address: #{@address_1.nickname}")
      expect(page).to have_button("Check Out With Address: #{@address_2.nickname}")
      expect(page).to have_button("Check Out With Address: #{@address_3.nickname}")

      click_on "Check Out With Address: #{@address_1.nickname}"

      order = Order.last

      expect(current_path).to eq(profile_orders_path)
      expect(page).to have_content("Shipping to: #{@address_1.nickname} address at #{@address_1.address}")
      expect(order.address.nickname).to eq(@address_1.nickname)
    end
  end
