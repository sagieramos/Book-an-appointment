class ReservationSerializer
  include JSONAPI::Serializer
  attributes :id, :customer_id, :reserve_for_use_date, :city, :created_at, :updated_at

  # belongs_to :customer, serializer: UserSerializer
  # has_many :items, serializer: ItemSerializer

  attribute :item_list do |object|
    page = 1
    per_page = 12
    if defined?(params) && params[:page].present? && params[:per_page].present?
      page = params[:page]
      per_page = params[:per_page]
    end

    paginated_items = object.paginated_item_list(page, per_page)
    items_attributes = paginated_items.map { |item| ItemSerializer.new(item).serializable_hash[:data][:attributes] }

    if paginated_items.total_entries > per_page
      items_attributes << { more_item: "/api/v1/reservations/#{object.id}/items" }
    end

    items_attributes
  end
end
