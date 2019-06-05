class Address < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :destroy
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :nickname, default: 'home'


  def has_completed_order?
  status_array = orders.map do |order|
      order.status
    end
    if status_array.include?("shipped")
      return true
    elsif status_array.include?("packaged")
      return true
    else
      return false
    end
  end

end
