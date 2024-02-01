class ItemSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :city, :finance_fee, :option_to_purchase_fee,
             :total_amount_payable, :duration, :apr_representative, :created_at, :updated_at, :image_url

  attribute :image_url do |object|
    object.image.url
  end
end
