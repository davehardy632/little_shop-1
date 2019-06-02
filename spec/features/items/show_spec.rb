require "rails_helper"

RSpec.describe "item show page" do
  before :each do
    @merchant = create(:merchant)
    @item = create(:item, user: @merchant)


    @user = create(:user)
    @address = @user.addresses.create(address: "1221 west 23rd ave", city: "Denver", state: "CO", zip: "21112")
    @order = Order.create(user: @user, address: @address, status: "pending")

    @order_item_1 = create(:fulfilled_order_item, item: @item, created_at: 4.days.ago, updated_at: 12.hours.ago, order: @order)
    @order_item_2 = create(:fulfilled_order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago, order: @order)
    @order_item_3 = create(:fulfilled_order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago, order: @order)
    @order_item_4 = create(:order_item, item: @item, created_at: 2.days.ago, updated_at: 1.day.ago, order: @order)
  end

  it "displays the items info" do
    visit item_path(@item)

    expect(page).to have_content(@item.name)
    expect(page).to have_content(@item.description)
    expect(page).to have_xpath("//img[@src='#{@item.image}']")
    expect(page).to have_content(@item.user.name)
    expect(page).to have_content(@item.inventory)
    expect(page).to have_content(@item.price)
  end

  it "shows rounded up average fulfillment time" do
    visit item_path(@item)

    expect(page).to have_content("Average Fulfillment Time: 2 days")
  end

  it "shows rounded down average fulfillment time" do
    create(:fulfilled_order_item, item: @item, created_at: 4.days.ago, updated_at: 1.day.ago, order: @order)
    visit item_path(@item)

    expect(page).to have_content("Average Fulfillment Time: 2 days")
  end

  it "displays no average fulfillment time if there are no order items" do
    merchant = create(:merchant)
    item = create(:item, user: merchant)
    order_item_4 = create(:order_item, item: item, created_at: 2.days.ago, updated_at: 1.day.ago, order: @order)
    visit item_path(item)

    expect(page).to_not have_content("Average Fulfillment Time:")
  end
end
