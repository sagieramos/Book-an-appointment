class User < ApplicationRecord
    has_many :reservations, foreign_key: 'customer_id'
    has_many :items, foreign_key: 'admin_id'
end
