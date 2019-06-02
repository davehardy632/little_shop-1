require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'validations' do
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of :quantity }
    it { should validate_numericality_of(:quantity).only_integer }
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(1) }
  end

  describe 'relationships' do
    it { should belong_to :order }
    it { should belong_to :item }
  end

  describe 'instance methods' do
    it '.subtotal' do
      user = create(:user)
      address = Address.create(address: "1211 west 24th ave", city: "Denver", state: "CO", zip: "21112", nickname: "work", user: user)
      order = Order.create(user: user, address: address, status: "pending")
      oi = create(:order_item, quantity: 5, price: 3, order: order)

      expect(oi.subtotal).to eq(15)
    end

    it '.fulfill' do
      user = create(:user)
      address = Address.create(address: "1211 west 24th ave", city: "Denver", state: "CO", zip: "21112", nickname: "work", user: user)
      order = Order.create(user: user, address: address, status: "pending")
      item = create(:item, inventory:2)
      oi1 = create(:order_item, quantity: 1, item: item, order: order)
      oi2 = create(:order_item, quantity: 1, item: item, order: order)
      oi3 = create(:order_item, quantity: 1, item: item, order: order)

      oi1.fulfill

      expect(oi1.fulfilled).to eq(true)
      expect(item.inventory).to eq(1)

      oi2.fulfill

      expect(oi1.fulfilled).to eq(true)
      expect(item.inventory).to eq(0)

      oi2.fulfill

      expect(oi2.fulfilled).to eq(true)
      expect(item.inventory).to eq(0)

      oi3.fulfill

      expect(oi2.fulfilled).to eq(true)
      expect(item.inventory).to eq(0)
    end

    it 'inventory_available' do
      item = create(:item, inventory:2)
      user = create(:user)
      address = Address.create(address: "1211 west 24th ave", city: "Denver", state: "CO", zip: "21112", nickname: "work", user: user)
      order = Order.create(user: user, address: address, status: "pending")
      oi1 = create(:order_item, quantity: 1, item: item, order: order)
      oi2 = create(:order_item, quantity: 2, item: item, order: order)
      oi3 = create(:order_item, quantity: 3, item: item, order: order)

      expect(oi1.inventory_available).to eq(true)
      expect(oi2.inventory_available).to eq(true)
      expect(oi3.inventory_available).to eq(false)
    end
  end
end
