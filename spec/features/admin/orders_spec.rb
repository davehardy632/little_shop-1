require 'rails_helper'

RSpec.describe 'Admin Order workflow', type: :feature do
  before :each do
    @admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    user_1, user_2, user_3, user_4 = create_list(:user, 4)
    address_1 = user_1.addresses.create(address: "1221 west 23rd ave", city: "Denver", state: "CO", zip: "21112")
    address_2 = user_2.addresses.create(address: "8854 east 27th ave", city: "Austin", state: "TX", zip: "21235")
    address_3 = user_3.addresses.create(address: "3223 Main blvd", city: "Des Moines", state: "IA", zip: "81664")
    address_4 = user_4.addresses.create(address: "7765 north 15th st", city: "Little Rock", state: "AK", zip: "90443")

    @order_1 = Order.create(user: user_1, address: address_1, status: "pending")
    @order_2 = Order.create(user: user_2, address: address_2, status: "packaged")
    @order_3 = Order.create(user: user_3, address: address_3, status: "shipped")
    @order_4 = Order.create(user: user_4, address: address_4, status: "cancelled")
  end
  describe 'admin order index page' do
    it 'shows all orders, ship button, etc' do
      visit admin_dashboard_path

      within '#packaged-orders' do
        within "#order-#{@order_2.id}" do
          expect(page).to have_link(@order_2.user.name)
          expect(page).to have_content("Order ID #{@order_2.id}")
          expect(page).to have_content("Created: #{@order_2.created_at}")
          expect(page).to have_button('Ship Order')
        end
      end

      within '#pending-orders' do
        within "#order-#{@order_1.id}" do
          expect(page).to have_link(@order_1.user.name)
          expect(page).to have_content("Order ID #{@order_1.id}")
          expect(page).to have_content("Created: #{@order_1.created_at}")
          expect(page).to_not have_button('Ship Order')
        end
      end

      within '#shipped-orders' do
        within "#order-#{@order_3.id}" do
          expect(page).to have_link(@order_3.user.name)
          expect(page).to have_content("Order ID #{@order_3.id}")
          expect(page).to have_content("Created: #{@order_3.created_at}")
          expect(page).to_not have_button('Ship Order')
        end
      end

      within '#cancelled-orders' do
        within "#order-#{@order_4.id}" do
          expect(page).to have_link(@order_4.user.name)
          expect(page).to have_content("Order ID #{@order_4.id}")
          expect(page).to have_content("Created: #{@order_4.created_at}")
          expect(page).to_not have_button('Ship Order')
        end
      end
    end

    it 'ships an order' do
      visit admin_dashboard_path

      within '#packaged-orders' do
        within "#order-#{@order_2.id}" do
          click_button('Ship Order')
        end
      end

      expect(current_path).to eq(admin_dashboard_path)

      within '#packaged-orders' do
        expect(page).to_not have_css("#order-#{@order_2.id}")
      end

      within '#shipped-orders' do
        within "#order-#{@order_2.id}" do
          expect(page).to have_link(@order_2.user.name)
          expect(page).to have_content("Order ID #{@order_2.id}")
        end
      end
    end
  end
end
