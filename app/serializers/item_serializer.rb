class ItemSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :city, :finance_fee, :option_to_purchase_fee,
             :total_amount_payable, :duration, :created_at, :updated_at, :image_url

  attribute :image_url do |object|
    object.image.url if object.image.present?
  end
end
