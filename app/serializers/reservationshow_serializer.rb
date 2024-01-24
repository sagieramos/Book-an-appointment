class ReservationshowSerializer
  include JSONAPI::Serializer
  attributes :id, :customer_id, :reserve_for_use_date, :city, :created_at, :updated_at
end
