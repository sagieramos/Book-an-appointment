class Item < ApplicationRecord
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  has_many :reservation_items
  has_many :reservations, through: :reservation_items

  def reservation_list
    reservations.includes(:user)
  end
end
