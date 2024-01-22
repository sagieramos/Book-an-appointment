class ItemSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :image, :description, :city, :created_at, :updated_at
end
