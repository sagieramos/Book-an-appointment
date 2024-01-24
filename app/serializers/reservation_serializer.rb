class ReservationSerializer
  include JSONAPI::Serializer
  attributes :id, :customer_id, :reserve_for_use_date, :city, :created_at, :updated_at

  # belongs_to :customer, serializer: UserSerializer
  # has_many :items, serializer: ItemSerializer

  attribute :item_list do |object|
    PAGE = 1
    PER_PAGE = 2

    paginated_items = object.paginated_item_list(PAGE, PER_PAGE)
    items_attributes = paginated_items.map { |item| ItemSerializer.new(item).serializable_hash[:data][:attributes] }

    options = paginated_items.total_entries > PER_PAGE
    items_attributes << { show_reservation: "/api/v1/reservations/#{object.id}" } if options

    items_attributes
  end
end
