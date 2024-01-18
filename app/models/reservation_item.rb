class ReservationItem < ApplicationRecord
  belongs_to :reservation
  belongs_to :item
end
