require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

admin_2 = create(:admin, name: "Admin 2", email: "admin2email@gmail.com", password: "password")
admin_address2 = admin_2.addresses.create(address: "1121 admin way", city: "Denver", state: "CO", zip: "80102")
admin = create(:admin, name: "Admin 1", email: "admin1email@gmail.com", password: "password")
  admin_address = admin.addresses.create(address: "1121 admin way", city: "Denver", state: "CO", zip: "80102")


merchant_1 = create(:merchant, name: "Merchant 1")
  merchant1_address = merchant_1.addresses.create(address: "1121 merchant way", city: "Austin", state: "TX", zip: "40987")

merchant_2 = create(:merchant, name: "Merchant 2", email: "merchant2email@gmail.com", password: "password")
  merchant2_address = merchant_2.addresses.create(address: "1121 merchant road", city: "Merchant Beach", state: "AK", zip: "11232")
    item_1 = create(:item, price: 2.00, user: merchant_2, inventory: 22)
    item_2 = create(:item, price: 3.00, user: merchant_2, inventory: 10)
    item_3 = create(:item, price: 3.00, user: merchant_2, inventory: 15)
    item_4 = create(:item, price: 300.00, user: merchant_2, inventory: 15)
      coupon = merchant_2.coupons.create!(name: "Coupon 1", discount: 10.00)
      coupon_2 = merchant_2.coupons.create!(name: "Coupon 2", discount: 5.00)
      coupon_3 = merchant_2.coupons.create!(name: "Coupon 3", discount: 7.00)
      coupon_4 = merchant_2.coupons.create!(name: "Coupon 4", discount: 3.00)
      coupon_5 = merchant_2.coupons.create!(name: "Coupon 5", discount: 2.00)

      user = create(:user, name: "User 1", email: "user1email@gmail.com", password: "password")
      user_address = user.addresses.create(address: "1121 user way", city: "Boston", state: "MA", zip: "50102")

merchant_2, merchant_3, merchant_4 = create_list(:merchant, 3)

inactive_merchant_1 = create(:inactive_merchant)
inactive_user_1 = create(:inactive_user)

item_1 = create(:item, user: merchant_1)
item_2 = create(:item, user: merchant_2)
item_3 = create(:item, user: merchant_3)
item_4 = create(:item, user: merchant_4)
create_list(:item, 10, user: merchant_1)

inactive_item_1 = create(:inactive_item, user: merchant_1)
inactive_item_2 = create(:inactive_item, user: inactive_merchant_1)

# Random.new_seed
# rng = Random.new

# order = create(:completed_order, user: user)
# create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1, created_at: (rng.rand(3)+1).days.ago, updated_at: rng.rand(59).minutes.ago)
# create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)
# create(:fulfilled_order_item, order: order, item: item_3, price: 3, quantity: 1, created_at: (rng.rand(5)+1).days.ago, updated_at: rng.rand(59).minutes.ago)
# create(:fulfilled_order_item, order: order, item: item_4, price: 4, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)

# # pending order
# order = create(:order, user: user)
# create(:order_item, order: order, item: item_1, price: 1, quantity: 1)
# create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).days.ago, updated_at: rng.rand(23).hours.ago)

# order = create(:cancelled_order, user: user)
# create(:order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)
# create(:order_item, order: order, item: item_3, price: 3, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)

# order = create(:completed_order, user: user)
# create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1, created_at: (rng.rand(4)+1).days.ago, updated_at: rng.rand(59).minutes.ago)
# create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)





puts 'seed data finished'
puts "Users created: #{User.count.to_i}"
# puts "Orders created: #{Order.count.to_i}"
puts "Items created: #{Item.count.to_i}"
# puts "OrderItems created: #{OrderItem.count.to_i}"
