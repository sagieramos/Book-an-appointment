PAGE = 1
PER_PAGE = 2

class ReservationSerializer
  include JSONAPI::Serializer
  attributes :id, :customer_id, :reserve_for_use_date, :created_at, :updated_at

  attribute :item_list do |object|
    paginated_items = object.paginated_item_list(PAGE, PER_PAGE)
    items_attributes = paginated_items.map { |item| ItemSerializer.new(item).serializable_hash[:data][:attributes] }

    # options = paginated_items.total_entries > PER_PAGE
    # items_attributes << { more: true } if options

    items_attributes
  end
end
