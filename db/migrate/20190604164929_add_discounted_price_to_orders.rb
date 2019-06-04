class AddDiscountedPriceToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :discounted_price, :decimal
  end
end
