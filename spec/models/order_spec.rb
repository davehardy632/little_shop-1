require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :address }
    it { should have_many :order_items }
    it { should have_many(:items).through(:order_items) }
  end

  describe 'instance methods' do
    before :each do
      user = create(:user)
      @item_1 = create(:item)
      @item_2 = create(:item)
      yesterday = 1.day.ago

      @address = Address.create(address: "1211 west 24th ave", city: "Denver", state: "CO", zip: "21112", nickname: "work", user: user)

      @order = Order.create(user: user, address: @address, status: "pending", created_at: yesterday)
      # @order = create(:order, user: user, created_at: yesterday, address: @address)
      @oi_1 = create(:order_item, order: @order, item: @item_1, price: 1, quantity: 1, created_at: yesterday, updated_at: yesterday)
      @oi_2 = create(:fulfilled_order_item, order: @order, item: @item_2, price: 2, quantity: 1, created_at: yesterday, updated_at: 2.hours.ago)

      @merchant = create(:merchant)
      @i1, @i2 = create_list(:item, 2, user: @merchant)
      # @o1, @o2 = create_list(:order, 2, address: @address)

      @o1 = Order.create(user: user, address: @address, status: "pending")
      @o2 = Order.create(user: user, address: @address, status: "pending")


      # @o3 = create(:packaged_order)
      @o3 = Order.create(user: user, address: @address, status: "packaged")
      # @o4 = create(:shipped_order)
      @o4 = Order.create(user: user, address: @address, status: "shipped")
      # @o5 = create(:cancelled_order)
      @o5 = Order.create(user: user, address: @address, status: "cancelled")
      create(:order_item, order: @o1, item: @i1, quantity: 1, price: 2)
      create(:order_item, order: @o1, item: @i2, quantity: 2, price: 2)
      create(:order_item, order: @o2, item: @i2, quantity: 4, price: 2)
      create(:order_item, order: @o3, item: @i1, quantity: 4, price: 2)
      create(:order_item, order: @o4, item: @i2, quantity: 5, price: 2)
      create(:order_item, order: @o5, item: @i1, quantity: 5, price: 2)
    end

    it '.total_item_count' do
      expect(@order.total_item_count).to eq(@oi_1.quantity + @oi_2.quantity)
    end

    it '.total_cost' do
      expect(@order.total_cost).to eq((@oi_1.quantity*@oi_1.price) + (@oi_2.quantity*@oi_2.price))
    end
  end

  describe 'class methods' do
    before :each do
      user = create(:user)
      @address = Address.create(address: "1211 west 24th ave", city: "Denver", state: "CO", zip: "21112", nickname: "work", user: user)

      @merchant = create(:merchant)
      @i1, @i2 = create_list(:item, 2, user: @merchant)

      # @o1, @o2, @o3, @o4, @o5 = create_list(:shipped_order, 5, user: user)

      @o1 = Order.create(user: user, address: @address, status: "shipped")
      @o2 = Order.create(user: user, address: @address, status: "shipped")
      @o3 = Order.create(user: user, address: @address, status: "shipped")
      @o4 = Order.create(user: user, address: @address, status: "shipped")
      @o5 = Order.create(user: user, address: @address, status: "shipped")





      oi1 = create(:fulfilled_order_item, order: @o1)
      oi2 = create(:fulfilled_order_item, order: @o2)
      oi3 = create(:fulfilled_order_item, order: @o3)
      oi4 = create(:fulfilled_order_item, order: @o4)
      oi5 = create(:fulfilled_order_item, order: @o5)

      # @o6 = create(:shipped_order, user: user)
      @o6 = Order.create(user: user, address: @address, status: "shipped")
      oi2 = create(:fulfilled_order_item, order: @o6)

      # @o7, @o8 = create_list(:order, 2, user: user)
      @o7 = Order.create(user: user, address: @address, status: "pending")
      @o8 = Order.create(user: user, address: @address, status: "pending")
      create(:order_item, order: @o7, item: @i1)
      create(:order_item, order: @o7)
      create(:order_item, order: @o8, item: @i2)

      # @packaged_orders = create_list(:packaged_order, 3, user: user)
      @op1 = Order.create(user: user, address: @address, status: "packaged")
      @op2 = Order.create(user: user, address: @address, status: "packaged")
      @op3 = Order.create(user: user, address: @address, status: "packaged")

      @packaged_orders = [@op1, @op2, @op3]

      create(:fulfilled_order_item, order: @packaged_orders[0])
      create(:fulfilled_order_item, order: @packaged_orders[1])
      create(:fulfilled_order_item, order: @packaged_orders[2])

      # @cancelled_orders = create_list(:cancelled_order, 2, user: user)
      @oc1 = Order.create(user: user, address: @address, status: "cancelled")
      @oc2 = Order.create(user: user, address: @address, status: "cancelled")

      @cancelled_orders = [@oc1, @oc2]

      create(:order_item, order: @cancelled_orders[0])
      create(:order_item, order: @cancelled_orders[1])
    end

    it '.pending_orders_for_merchant' do
      expect(Order.pending_orders_for_merchant(@merchant.id)).to eq([@o7, @o8])
    end

    it '.orders_by_status(status)' do
      expect(Order.orders_by_status(:pending)).to eq([@o7, @o8])
      expect(Order.orders_by_status(:packaged)).to eq([@packaged_orders[0], @packaged_orders[1], @packaged_orders[2]])
      expect(Order.orders_by_status(:shipped)).to eq([@o1, @o2, @o3, @o4, @o5, @o6])
      expect(Order.orders_by_status(:cancelled)).to eq([@cancelled_orders[0], @cancelled_orders[1]])
    end
    it '.pending_orders' do
      expect(Order.pending_orders).to eq([@o7, @o8])
    end
    it '.packaged_orders' do
      expect(Order.packaged_orders).to eq([@packaged_orders[0], @packaged_orders[1], @packaged_orders[2]])
    end
    it '.shipped_orders' do
      expect(Order.shipped_orders).to eq([@o1, @o2, @o3, @o4, @o5, @o6])
    end
    it '.cancelled_orders' do
      expect(Order.cancelled_orders).to eq([@cancelled_orders[0], @cancelled_orders[1]])
    end

    it '.sorted_by_items_shipped' do
      expect(Order.sorted_by_items_shipped).to eq([@o6, @o5, @o4, @o3, @o2, @o1])
    end
  end

  describe 'instance methods' do
    before :each do
      user = create(:user)
      @address = Address.create(address: "1211 west 24th ave", city: "Denver", state: "CO", zip: "21112", nickname: "work", user: @user)
      @item_1 = create(:item)
      @item_2 = create(:item)
      yesterday = 1.day.ago

      # @order = create(:order, user: user, created_at: yesterday)
      @order = Order.create(user: user, address: @address, status: "pending", created_at: yesterday)
      @oi_1 = create(:order_item, order: @order, item: @item_1, price: 1, quantity: 1, created_at: yesterday, updated_at: yesterday)
      @oi_2 = create(:fulfilled_order_item, order: @order, item: @item_2, price: 2, quantity: 1, created_at: yesterday, updated_at: 2.hours.ago)

      @merchant = create(:merchant)
      @i1, @i2 = create_list(:item, 2, user: @merchant)
      # @o1, @o2 = create_list(:order, 2)
      @o1 = Order.create(user: user, address: @address, status: "pending")
      @o2 = Order.create(user: user, address: @address, status: "pending")

      # @o3 = create(:shipped_order)
      @o3 = Order.create(user: user, address: @address, status: "cancelled")
      # @o4 = create(:cancelled_order)
      @o4 = Order.create(user: user, address: @address, status: "cancelled")
      create(:order_item, order: @o1, item: @i1, quantity: 1, price: 2)
      create(:order_item, order: @o1, item: @i2, quantity: 2, price: 2)
      create(:order_item, order: @o2, item: @i2, quantity: 4, price: 2)
      create(:order_item, order: @o3, item: @i1, quantity: 4, price: 2)
      create(:order_item, order: @o4, item: @i2, quantity: 5, price: 2)
    end

    it '.total_quantity_for_merchant' do
      expect(@o1.total_quantity_for_merchant(@merchant.id)).to eq(3)
      expect(@o2.total_quantity_for_merchant(@merchant.id)).to eq(4)
    end

    it '.total_item_count' do
      expect(@order.total_item_count).to eq(@oi_1.quantity + @oi_2.quantity)
    end

    it '.total_price_for_merchant' do
      expect(@o1.total_price_for_merchant(@merchant.id)).to eq(6.0)
      expect(@o2.total_price_for_merchant(@merchant.id)).to eq(8.0)
    end

    it '.order_items_for_merchant' do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      user = create(:user)

      @address = Address.create(address: "1211 west 24th ave", city: "Denver", state: "CO", zip: "21112", nickname: "work", user: user)

      # order = create(:order, user: user)
      order = Order.create(user: user, address: @address, status: "pending")
      item1 = create(:item, user: merchant1)
      item2 = create(:item, user: merchant2)
      item3 = create(:item, user: merchant1)
      oi1 = create(:order_item, order: order, item: item1, quantity: 1, price: 2)
      oi2 = create(:order_item, order: order, item: item2, quantity: 2, price: 3)
      oi3 = create(:order_item, order: order, item: item3, quantity: 3, price: 4)

      expect(order.order_items_for_merchant(merchant1.id)).to eq([oi1, oi3])
    end
  end
end
