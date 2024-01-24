class Reservation < ApplicationRecord
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  has_many :reservation_items
  has_many :items, through: :reservation_items

  def paginated_item_list(page = 1, per_page = 10)
    items.paginate(page:, per_page:).to_a
  end

  def self.search(query)
    where('city ILIKE ?', "%#{query}%")
  end
end
