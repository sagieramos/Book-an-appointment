class AdminItemSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :image, :description, :city, :created_at, :updated_at, :reserving_ids, :reserving_usernames

  attribute :reserving_ids do |object|
    object.reservations.pluck(:id).join(',')
  end

  attribute :reserving_usernames do |object|
    object.reservations.includes(:customer).pluck('users.username').join(',')
  end
end
