class ReservationSerializer
  include JSONAPI::Serializer
  attributes :id, :customer_id, :reserve_for_use_date, :city, :created_at, :updated_at

  has_many :items, serializer: ItemSerializer, meta: proc { |record, _params|
    { items: record.items.map { |item| ItemSerializer.new(item).serializable_hash[:data][:attributes] } }
  }
end
