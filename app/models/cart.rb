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

  def discounted_total
    coupon = Coupon.find(contents["coupon_id"])
    merchant = coupon.user
    items = remove_coupon
    items.sum do |item_id, quantity|
     item = Item.find(item_id)
       item.price * quantity if item.user == merchant
    end - coupon.discount
  end

end
