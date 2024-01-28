class Reservation < ApplicationRecord
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  has_many :reservation_items, dependent: :destroy
  has_many :items, through: :reservation_items

  accepts_nested_attributes_for :reservation_items, allow_destroy: true

  validates :reserve_for_use_date, presence: true
  validate :reserve_for_use_date_in_future

  def paginated_item_list(page = 1, per_page = 10)
    items.order(created_at: :desc).paginate(page:, per_page:)
  end

  def self.search(query)
    where('reserve_for_use_date ILIKE ?', "%#{query}%")
  end

  def self.sort_by_date
    order(reserve_for_use_date: :asc)
  end

  def update_with_items(attributes)
    self.reserve_for_use_date = attributes[:reserve_for_use_date]

    process_reservation_items(attributes[:reservation_items_attributes])

    save
  end

  def self.create_or_update_reservation(user, reservation_params)
    existing_reservation = user.reservations.find_by(reserve_for_use_date: reservation_params[:reserve_for_use_date])

    if existing_reservation.present?
      existing_reservation.process_reservation_items(reservation_params[:reservation_items_attributes])
      existing_reservation
    else
      user.reservations.create(reservation_params)
    end
  end

  def process_reservation_items(items_attributes)
    return unless items_attributes.present?

    items_attributes.each do |item_params|
      item_id = item_params[:item_id]
      item_id = item_params[:id] if item_params[:id].present? # For existing items

      if item_params[:_destroy] == true # Marked for deletion
        destroy_reservation_item(item_id)
      elsif valid_new_item?(item_id)
        create_reservation_item(item_id)
      end
    end
  end

  private

  def destroy_reservation_item(item_id)
    reservation_item = reservation_items.find_by(item_id:)
    reservation_item&.destroy
  end

  def valid_new_item?(item_id)
    item_id.present? && !item_ids.include?(item_id) && !items.exists?(item_id)
  end

  def create_reservation_item(item_id)
    reservation_items.create(item_id:)
  end

  def reserve_for_use_date_in_future
    return unless reserve_for_use_date.present? && reserve_for_use_date <= Date.today

    errors.add(:reserve_for_use_date,
               'must be in the future')
  end
end
