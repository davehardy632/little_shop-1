class Cart
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
    @contents.default = 0
  end

  def total_item_count
    @contents.values.sum
  end

  def add_item(item_id)
    @contents[item_id.to_s] += 1
  end

  def remove_item(item_id)
    @contents[item_id.to_s] -= 1
    @contents.delete(item_id.to_s) if count_of(item_id) == 0
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def items
    @items ||= load_items
  end

  def load_items
    items = remove_coupon
    items.map do |item_id, quantity|
    item = Item.find(item_id)
      [item, quantity]
    end.to_h
  end

  def total
    items.sum do |item, quantity|
      item.price * quantity
    end
  end

  def subtotal(item)
    count_of(item.id) * item.price
  end

  def add_coupon(coupon_id)
    @contents["coupon_id"] = coupon_id
  end

  def remove_coupon
    contents.except("coupon_id")
  end

  def merchant_items
    coupon = Coupon.find(contents["coupon_id"])
    merchant = coupon.user
    items = remove_coupon
    other_items = Hash.new
    merchant_items = Hash.new(0)
      items.each do |item_id, quantity|
      item = Item.find(item_id)
      if item.user == merchant
        merchant_items[item_id] = quantity
      else
        other_items[item_id] = quantity
      end
    end
    merchant_items
  end

  def merchant_total
    discount = merchant_items
    full_price = total
    discount.sum do |item_id, quantity|
      item = Item.find(item_id)
      item.price * quantity
    end
  end

  def discounted_total
    coupon = Coupon.find(contents["coupon_id"])
    discount = coupon.discount
    after_discount = merchant_total - discount
    total_difference = total - merchant_total
    total_discount = total_difference + after_discount
    total_discount
  end
end
