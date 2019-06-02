require 'rails_helper'

describe Address do
  describe "Validations" do
    it {should validate_presence_of :address }
    it {should validate_presence_of :city }
    it {should validate_presence_of :state }
    it {should validate_presence_of :zip }
    # it {should validate_presence_of :nickname }
  end
  describe "relationships" do
    it {should belong_to :user}
    it {should have_many :orders}
  end

  describe "instance methods" do
    before :each do
      @user = create(:user)

      @address_1 = @user.addresses.create(address: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Work")
      @address_2 = @user.addresses.create(address: "1421 east 23rd ave", city: "Austin", state: "TX", zip: "80221",  nickname: "Home")
      @address_3 = @user.addresses.create(address: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Other")

      @shipped_order = Order.create!(status: "shipped", user: @user, address: @address_1)
      @packaged_order = Order.create!(status: "packaged", user: @user, address: @address_2)
      @pending_order = Order.create!(status: "pending", user: @user, address: @address_3)

      @item_1 = create(:item)
      @item_2 = create(:item)
      @item_3 = create(:item)

      @oi_1 = create(:fulfilled_order_item, item: @item_1, order: @shipped_order)
      @oi_2 = create(:fulfilled_order_item, item: @item_2, order: @shipped_order)
      @oi_3 = create(:fulfilled_order_item, item: @item_3, order: @shipped_order)

      @oi_4 = create(:fulfilled_order_item, item: @item_1, order: @packaged_order)
      @oi_5 = create(:fulfilled_order_item, item: @item_2, order: @packaged_order)

      @oi_6 = create(:fulfilled_order_item, item: @item_3, order: @pending_order)

    end
    it ".has_completed_order?" do

      expect(@address_1.has_completed_order?).to eq(true)
      expect(@address_2.has_completed_order?).to eq(true)
      expect(@address_3.has_completed_order?).to eq(false)
    end
  end
end
