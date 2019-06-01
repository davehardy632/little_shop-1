class Address < ApplicationRecord
  belongs_to :user
  validates_presence_of :address_line
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :nickname
end
