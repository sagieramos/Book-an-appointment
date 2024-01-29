class User < ApplicationRecord
  has_many :reservations, foreign_key: 'customer_id'
  has_many :items, foreign_key: 'admin_id'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  # jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  before_validation :trim_string_attributes

  validates :username, presence: true, uniqueness: true, length: { maximum: 30 }
  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }
  validates :email, presence: true, length: { maximum: 50 }

  def self.search(query)
    where('username ILIKE ? OR first_name ILIKE ? OR last_name LIKE ? OR email ILIKE ?', "%#{query}%", "%#{query}%",
          "%#{query}%", "%#{query}%")
  end

  private

  def trim_string_attributes
    attributes.each do |attr, value|
      self[attr] = value.strip if value.respond_to?(:strip)
    end
  end
end
