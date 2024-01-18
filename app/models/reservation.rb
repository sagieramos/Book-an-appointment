class Reservation < ApplicationRecord
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  has_many :reservation_items
  has_many :items, through: :reservation_items
end
