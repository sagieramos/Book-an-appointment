class Item < ApplicationRecord
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  has_many :reservation_items, dependent: :destroy
  has_many :reservations, through: :reservation_items

  mount_uploader :image, ImageUploader

  accepts_nested_attributes_for :reservation_items

  validates :name, presence: true
  validates :description, presence: true

  def reservation_list
    reservations.includes(:user)
  end

  def self.search(query)
    where('name ILIKE ? OR description ILIKE ? OR city ILIKE ?', "%#{query}%", "%#{query}%", "%#{query}%")
  end
end
