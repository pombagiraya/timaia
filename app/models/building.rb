class Building < ApplicationRecord
  belongs_to :user
  has_many :apartments, dependent: :destroy

  validates :building_name, presence: true, length: {minimum: 2}
  validates :super_name, presence: true, length: {minimum: 2}
  validates :super_email, presence: true, length: {minimum: 3}
  validates :zipcode, presence: true
  validates :city, presence: true, length: {minimum: 2}
  validates :province, presence: true, length: { is: 2 }
  validates :country, presence: true, length: {minimum: 2}
  validates :user_id, presence: true
end
