class ItemSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :image, :description, :city, :finance_fee, :option_to_purchase_fee,
             :total_amount_payable, :duration, :created_at, :updated_at
end
