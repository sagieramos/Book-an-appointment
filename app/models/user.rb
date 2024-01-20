class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :trim_string_attributes

validates :username, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }
  validates :email, presence: true, length: { maximum: 50 }

  has_many :reservations, foreign_key: 'customer_id'
  has_many :items, foreign_key: 'admin_id'

  private

  def trim_string_attributes
    attributes.each do |attr, value|
      self[attr] = value.strip if value.respond_to?(:strip)
    end
  end
end
