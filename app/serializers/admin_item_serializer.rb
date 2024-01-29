class AdminItemSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :city, :finance_fee, :option_to_purchase_fee,
             :total_amount_payable, :duration, :apr_representative, :created_at, :updated_at,
             :image_url, :reserving_ids, :reserving_usernames

  attribute :reserving_ids do |object|
    object.reservations.pluck(:id).join(',')
  end

  attribute :reserving_usernames do |object|
    object.reservations.includes(:customer).pluck('users.username').join(',')
  end
end
