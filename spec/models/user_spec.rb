require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    # as user
    it { should have_many :orders }
    it { should have_many(:order_items).through(:orders)}
    # as merchant
    it { should have_many :items }
    it { should have_many :addresses }
    it { should have_many :coupons }
  end

  describe 'roles' do
    it 'can be created as a default user' do
      user = User.create(
        email: "email",
        password: "password",
        name: "name",
      )
      expect(user.role).to eq('default')
      expect(user.default?).to be_truthy
    end

    it 'can be created as a merchant' do
      user = User.create(
        email: "email",
        password: "password",
        name: "name",
        role: 1
      )
      expect(user.role).to eq('merchant')
      expect(user.merchant?).to be_truthy
    end

    it 'can be created as an admin' do
      user = User.create(
        email: "email",
        password: "password",
        name: "name",
        role: 2
      )
      expect(user.role).to eq('admin')
      expect(user.admin?).to be_truthy
    end
  end

  describe 'instance methods' do
    before :each do
      # @u1 = create(:user, state: "CO", city: "Anywhere")
      @u1 = User.create(name: "user", email: "user@gmail.com", password: "password")
      @address_1 = @u1.addresses.create(address: "1121 west 32nd ave", city: "Anywhere", state: "CO", zip: "22122")
      # @u2 = create(:user, state: "OK", city: "Tulsa")
      @u2 = User.create(name: "user 2", email: "user2@gmail.com", password: "password2")
      @address_2 = @u2.addresses.create(address: "1441 north 30th ave", city: "Tulsa", state: "OK", zip: "22332")

      @u3 = create(:user, state: "IA", city: "Anywhere")
      @u3 = User.create(name: "user 3", email: "user3@gmail.com", password: "password3")
      @address_3 = @u3.addresses.create(address: "1155 east 22nd ave", city: "Anywhere", state: "IA", zip: "11312")

      # u4 = create(:user, state: "IA", city: "Des Moines")
      u4 = User.create(name: "user 4", email: "user4@gmail.com", password: "password4")
      address_4 = u4.addresses.create(address: "1521 west 44th ave", city: "Des Moines", state: "IA", zip: "24532")

      # u5 = create(:user, state: "IA", city: "Des Moines")
      u5 = User.create(name: "user 5", email: "user5@gmail.com", password: "password5")
      address_5 = u5.addresses.create(address: "1321 west 11th ave", city: "Des Moines", state: "IA", zip: "22652")

      # u6 = create(:user, state: "IA", city: "Des Moines")
      u6 = User.create(name: "user 6", email: "user6@gmail.com", password: "password6")
      address_6 = u6.addresses.create(address: "1661 west 26th ave", city: "Des Moines", state: "IA", zip: "56332")


      @m1 = create(:merchant)
      @i1 = create(:item, merchant_id: @m1.id, inventory: 20)
      @i2 = create(:item, merchant_id: @m1.id, inventory: 20)
      @i3 = create(:item, merchant_id: @m1.id, inventory: 20)
      @i4 = create(:item, merchant_id: @m1.id, inventory: 20)
      @i5 = create(:item, merchant_id: @m1.id, inventory: 20)
      @i6 = create(:item, merchant_id: @m1.id, inventory: 20)
      @i7 = create(:item, merchant_id: @m1.id, inventory: 20)
      @i8 = create(:item, merchant_id: @m1.id, inventory: 20)
      @i9 = create(:inactive_item, merchant_id: @m1.id)

      @m2 = create(:merchant)
      @i10 = create(:item, merchant_id: @m2.id, inventory: 20)


      #
      # @address_1 = @u1.addresses.create(address: "1121 west 32nd ave", city: "Anywhere", state: "CO", zip: "22122")
      # @address_2 = @u2.addresses.create(address: "1441 north 30th ave", city: "Tulsa", state: "OK", zip: "22332")
      # @address_3 = @u3.addresses.create(address: "1155 east 22nd ave", city: "Anywhere", state: "IA", zip: "11312")
      # address_4 = u4.addresses.create(address: "1521 west 44th ave", city: "Des Moines", state: "IA", zip: "24532")
      # address_5 = u5.addresses.create(address: "1321 west 11th ave", city: "Des Moines", state: "IA", zip: "22652")
      # address_6 = u6.addresses.create(address: "1661 west 26th ave", city: "Des Moines", state: "IA", zip: "56332")

      # o1 = create(:shipped_order, user: @u1, address: @address_1)
      o1 = Order.create(user: @u1, address: @address_1, status: "shipped")
        # o2 = create(:shipped_order, user: @u2, address: @address_2)
      o2 = Order.create(user: @u2, address: @address_2, status: "shipped")
      # o3 = create(:shipped_order, user: @u3, address: @address_3)
      o3 = Order.create(user: @u3, address: @address_3, status: "shipped")
      # o4 = create(:shipped_order, user: @u1, address: @address_1)
      o4 = Order.create(user: @u1, address: @address_1, status: "shipped")
      # o5 = create(:shipped_order, user: @u1, address: @address_1)
      o5 = Order.create(user: @u1, address: @address_1, status: "shipped")
      # o6 = create(:cancelled_order, user: u5)
      o6 = Order.create(user: u5, address: address_5, status: "cancelled")
      # o7 = create(:order, user: u6)
      o7 = Order.create(user: u6, address: address_6, status: "pending")

      @oi1 = create(:order_item, item: @i1, order: o1, quantity: 2, created_at: 1.days.ago)
      @oi2 = create(:order_item, item: @i2, order: o2, quantity: 8, created_at: 7.days.ago)
      @oi3 = create(:order_item, item: @i2, order: o3, quantity: 6, created_at: 7.days.ago)
      @oi4 = create(:order_item, item: @i3, order: o3, quantity: 4, created_at: 6.days.ago)
      @oi5 = create(:order_item, item: @i4, order: o4, quantity: 3, created_at: 4.days.ago)
      @oi6 = create(:order_item, item: @i5, order: o5, quantity: 1, created_at: 5.days.ago)
      @oi7 = create(:order_item, item: @i6, order: o6, quantity: 2, created_at: 3.days.ago)
      @oi1.fulfill
      @oi2.fulfill
      @oi3.fulfill
      @oi4.fulfill
      @oi5.fulfill
      @oi6.fulfill
      @oi7.fulfill
    end

    it '.active_items' do
      expect(@m2.active_items).to eq([@i10])
      expect(@m1.active_items).to eq([@i1, @i2, @i3, @i4, @i5, @i6, @i7, @i8])
    end

    it '.top_items_sold_by_quantity' do
      expect(@m1.top_items_sold_by_quantity(5).length).to eq(5)
      expect(@m1.top_items_sold_by_quantity(5)[0].name).to eq(@i2.name)
      expect(@m1.top_items_sold_by_quantity(5)[0].quantity).to eq(14)
      expect(@m1.top_items_sold_by_quantity(5)[1].name).to eq(@i3.name)
      expect(@m1.top_items_sold_by_quantity(5)[1].quantity).to eq(4)
      expect(@m1.top_items_sold_by_quantity(5)[2].name).to eq(@i4.name)
      expect(@m1.top_items_sold_by_quantity(5)[2].quantity).to eq(3)
      expect(@m1.top_items_sold_by_quantity(5)[3].name).to eq(@i1.name)
      expect(@m1.top_items_sold_by_quantity(5)[3].quantity).to eq(2)
      expect(@m1.top_items_sold_by_quantity(5)[4].name).to eq(@i5.name)
      expect(@m1.top_items_sold_by_quantity(5)[4].quantity).to eq(1)
    end

    it '.total_items_sold' do
      expect(@m1.total_items_sold).to eq(24)
    end

    it '.percent_of_items_sold' do
      expect(@m1.percent_of_items_sold.round(2)).to eq(17.39)
    end

    it '.total_inventory_remaining' do
      expect(@m1.total_inventory_remaining).to eq(138)
    end

    it '.top_states_by_items_shipped' do
      expect(@m1.top_states_by_items_shipped(3)[0].state).to eq("IA")
      expect(@m1.top_states_by_items_shipped(3)[0].quantity).to eq(10)
      expect(@m1.top_states_by_items_shipped(3)[1].state).to eq("OK")
      expect(@m1.top_states_by_items_shipped(3)[1].quantity).to eq(8)
      expect(@m1.top_states_by_items_shipped(3)[2].state).to eq("CO")
      expect(@m1.top_states_by_items_shipped(3)[2].quantity).to eq(6)
    end

    it '.top_cities_by_items_shipped' do
      expect(@m1.top_cities_by_items_shipped(3)[0].city).to eq("Anywhere")
      expect(@m1.top_cities_by_items_shipped(3)[0].state).to eq("IA")
      expect(@m1.top_cities_by_items_shipped(3)[0].quantity).to eq(10)
      expect(@m1.top_cities_by_items_shipped(3)[1].city).to eq("Tulsa")
      expect(@m1.top_cities_by_items_shipped(3)[1].state).to eq("OK")
      expect(@m1.top_cities_by_items_shipped(3)[1].quantity).to eq(8)
      expect(@m1.top_cities_by_items_shipped(3)[2].city).to eq("Anywhere")
      expect(@m1.top_cities_by_items_shipped(3)[2].state).to eq("CO")
      expect(@m1.top_cities_by_items_shipped(3)[2].quantity).to eq(6)
    end

    it '.top_users_by_money_spent' do
      expect(@m1.top_users_by_money_spent(3)[0].name).to eq(@u3.name)
      expect(@m1.top_users_by_money_spent(3)[0].total.to_f).to eq(66.00)
      expect(@m1.top_users_by_money_spent(3)[1].name).to eq(@u1.name)
      expect(@m1.top_users_by_money_spent(3)[1].total.to_f).to eq(43.50)
      expect(@m1.top_users_by_money_spent(3)[2].name).to eq(@u2.name)
      expect(@m1.top_users_by_money_spent(3)[2].total.to_f).to eq(36.00)
    end

    it '.top_user_by_order_count' do
      expect(@m1.top_user_by_order_count.name).to eq(@u1.name)
      expect(@m1.top_user_by_order_count.count).to eq(3)
    end

    it '.top_user_by_item_count' do
      expect(@m1.top_user_by_item_count.name).to eq(@u3.name)
      expect(@m1.top_user_by_item_count.quantity).to eq(10)
    end
  end

  describe 'class methods' do
    it ".active_merchants" do
      active_merchants = create_list(:merchant, 3)
      inactive_merchant = create(:inactive_merchant)

      expect(User.active_merchants).to eq(active_merchants)
    end

    it '.default_users' do
      users = create_list(:user, 3)
      merchant = create(:merchant)
      admin = create(:admin)

      expect(User.default_users).to eq(users)
    end

    describe "statistics" do
      before :each do
        # Order.create(user: u6, address: address_6, status: "pending")
        u1 = create(:user)
          ad1 = u1.addresses.create(address: "1521 west 44th ave", city: "Fairfield", state: "CO", zip: "24532")

        u2 = create(:user)
          ad2 = u2.addresses.create(address: "1521 west 44th ave", city: "OKC", state: "OK", zip: "22232")

        u3 = create(:user)
          ad3 = u3.addresses.create(address: "1521 west 44th ave", city: "Fairfield", state: "IA", zip: "24532")

        u4 = create(:user)
          ad4 = u4.addresses.create(address: "1521 west 44th ave", city: "Des Moines", state: "IA", zip: "24222")

        u5 = create(:user)
          ad5 = u5.addresses.create(address: "1521 west 44th ave", city: "Des Moines", state: "IA", zip: "24533")

        u6 = create(:user)
          ad6 = u6.addresses.create(address: "1521 west 44th ave", city: "Des Moines", state: "IA", zip: "245367")


        @m1, @m2, @m3, @m4, @m5, @m6, @m7 = create_list(:merchant, 7)
        i1 = create(:item, merchant_id: @m1.id)
        i2 = create(:item, merchant_id: @m2.id)
        i3 = create(:item, merchant_id: @m3.id)
        i4 = create(:item, merchant_id: @m4.id)
        i5 = create(:item, merchant_id: @m5.id)
        i6 = create(:item, merchant_id: @m6.id)
        i7 = create(:item, merchant_id: @m7.id)

        # o1 = create(:shipped_order, user: u1)
        o1 = Order.create(user: u1, address: ad1, status: "shipped")

        # o2 = create(:shipped_order, user: u2)
        o2 = Order.create(user: u2, address: ad2, status: "shipped")

        # o3 = create(:shipped_order, user: u3)
        o3 = Order.create(user: u3, address: ad3, status: "shipped")

        # o4 = create(:shipped_order, user: u1)
        o4 = Order.create(user: u1, address: ad1, status: "shipped")

        # o5 = create(:cancelled_order, user: u1)
        o5 = Order.create(user: u5, address: ad5, status: "cancelled")

        # o6 = create(:shipped_order, user: u6)
        o6 = Order.create(user: u6, address: ad6, status: "shipped")

        # o7 = create(:shipped_order, user: u6)
        o7 = Order.create(user: u6, address: ad6, status: "shipped")

        oi1 = create(:fulfilled_order_item, item: i1, order: o1, created_at: 1.days.ago)
        oi2 = create(:fulfilled_order_item, item: i2, order: o2, created_at: 7.days.ago)
        oi3 = create(:fulfilled_order_item, item: i3, order: o3, created_at: 6.days.ago)
        oi4 = create(:order_item, item: i4, order: o4, created_at: 4.days.ago)
        oi5 = create(:order_item, item: i5, order: o5, created_at: 5.days.ago)
        oi6 = create(:fulfilled_order_item, item: i6, order: o6, created_at: 3.days.ago)
        oi7 = create(:fulfilled_order_item, item: i7, order: o7, created_at: 2.days.ago)
      end

      it ".merchants_sorted_by_revenue" do
        expect(User.merchants_sorted_by_revenue).to eq([@m7, @m6, @m3, @m2, @m1])
      end

      it ".top_merchants_by_revenue()" do
        expect(User.top_merchants_by_revenue(3)).to eq([@m7, @m6, @m3])
      end

      it ".merchants_sorted_by_fulfillment_time" do
        expect(User.merchants_sorted_by_fulfillment_time(1).length).to eq(1)
        expect(User.merchants_sorted_by_fulfillment_time(10).length).to eq(5)
        expect(User.merchants_sorted_by_fulfillment_time(10)).to eq([@m1, @m7, @m6, @m3, @m2])
      end

      it ".top_merchants_by_fulfillment_time" do
        expect(User.top_merchants_by_fulfillment_time(3)).to eq([@m1, @m7, @m6])
      end

      it ".bottom_merchants_by_fulfillment_time" do
        expect(User.bottom_merchants_by_fulfillment_time(3)).to eq([@m2, @m3, @m6])
      end

      it ".top_user_states_by_order_count" do
        expect(User.top_user_states_by_order_count(3)[0].state).to eq("IA")
        expect(User.top_user_states_by_order_count(3)[0].order_count).to eq(3)
        expect(User.top_user_states_by_order_count(3)[1].state).to eq("CO")
        expect(User.top_user_states_by_order_count(3)[1].order_count).to eq(2)
        expect(User.top_user_states_by_order_count(3)[2].state).to eq("OK")
        expect(User.top_user_states_by_order_count(3)[2].order_count).to eq(1)
      end

      it ".top_user_cities_by_order_count" do
        expect(User.top_user_cities_by_order_count(3)[0].state).to eq("CO")
        expect(User.top_user_cities_by_order_count(3)[0].city).to eq("Fairfield")
        expect(User.top_user_cities_by_order_count(3)[0].order_count).to eq(2)
        expect(User.top_user_cities_by_order_count(3)[1].state).to eq("IA")
        expect(User.top_user_cities_by_order_count(3)[1].city).to eq("Des Moines")
        expect(User.top_user_cities_by_order_count(3)[1].order_count).to eq(2)
        expect(User.top_user_cities_by_order_count(3)[2].state).to eq("IA")
        expect(User.top_user_cities_by_order_count(3)[2].city).to eq("Fairfield")
        expect(User.top_user_cities_by_order_count(3)[2].order_count).to eq(1)
      end
    end
  end
end
