require 'rails_helper'

RSpec.describe 'merchant dashboard' do
  before :each do
    @merchant = create(:merchant)
    @admin = create(:admin)
    @i1, @i2 = create_list(:item, 2, user: @merchant)

    @user = create(:user)
    @address = @user.addresses.create(address: "1221 west 23rd ave", city: "Denver", state: "CO", zip: "21112")
    @o1 = Order.create(user: @user, address: @address, status: "pending")
    @o2 = Order.create(user: @user, address: @address, status: "pending")
    @o3 = Order.create(user: @user, address: @address, status: "shipped")
    @o4 = Order.create(user: @user, address: @address, status: "cancelled")

    # @o1, @o2 = create_list(:order, 2)


    # @o3 = create(:shipped_order)
    # @o4 = create(:cancelled_order)
    create(:order_item, order: @o1, item: @i1, quantity: 1, price: 2)
    create(:order_item, order: @o1, item: @i2, quantity: 2, price: 2)
    create(:order_item, order: @o2, item: @i2, quantity: 4, price: 2)
    create(:order_item, order: @o3, item: @i1, quantity: 4, price: 2)
    create(:order_item, order: @o4, item: @i2, quantity: 5, price: 2)
  end

  describe 'merchant user visits their profile' do
    describe 'shows merchant information' do
      scenario 'as a merchant' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        visit dashboard_path
        expect(page).to_not have_button("Downgrade to User")
      end
      scenario 'as an admin' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        visit admin_merchant_path(@merchant)
      end
      after :each do
        expect(page).to have_content(@merchant.name)
        expect(page).to have_content("Email: #{@merchant.email}")
        @merchant.addresses.each do |address|
        expect(page).to have_content("Address: #{address.address}")
        expect(page).to have_content("City: #{address.city}")
        expect(page).to have_content("State: #{address.state}")
        expect(page).to have_content("Zip: #{address.zip}")
        end
      end
    end
  end

  describe 'merchant user with orders visits their profile' do
    before :each do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_path
    end
    it 'shows merchant information' do
      expect(page).to have_content(@merchant.name)
      expect(page).to have_content("Email: #{@merchant.email}")
      @merchant.addresses.each do |address|
      expect(page).to have_content("Address: #{address.address}")
      expect(page).to have_content("City: #{address.city}")
      expect(page).to have_content("State: #{address.state}")
      expect(page).to have_content("Zip: #{address.zip}")
      end
    end

    it 'does not have a link to edit information' do
      expect(page).to_not have_link('Edit')
    end

    it 'shows pending order information' do
      within("#order-#{@o1.id}") do
        expect(page).to have_link(@o1.id)
        expect(page).to have_content(@o1.created_at)
        expect(page).to have_content(@o1.total_quantity_for_merchant(@merchant.id))
        expect(page).to have_content(@o1.total_price_for_merchant(@merchant.id))
      end
      within("#order-#{@o2.id}") do
        expect(page).to have_link(@o2.id)
        expect(page).to have_content(@o2.created_at)
        expect(page).to have_content(@o2.total_quantity_for_merchant(@merchant.id))
        expect(page).to have_content(@o2.total_price_for_merchant(@merchant.id))
      end
    end

    it 'does not show non-pending orders' do
      expect(page).to_not have_css("#order-#{@o3.id}")
      expect(page).to_not have_css("#order-#{@o4.id}")
    end

    describe 'shows a link to merchant items' do
      scenario 'as a merchant' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        visit dashboard_path
        click_link('Items for Sale')
        expect(current_path).to eq(dashboard_items_path)
      end
      scenario 'as an admin' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        visit admin_merchant_path(@merchant)
        expect(page.status_code).to eq(200)
        click_link('Items for Sale')
        expect(current_path).to eq(admin_merchant_items_path(@merchant))
      end
    end
  end
end
