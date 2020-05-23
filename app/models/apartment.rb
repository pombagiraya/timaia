class Apartment < ApplicationRecord
  belongs_to :building
  belongs_to :user
  has_many :payments, dependent: :destroy

  validates :apt_number, presence: true
  validates :bill, presence: true
  validates :building_id, presence: true
  validates :user_id, presence: true

  def self.search(user)
    user = Apartment.user_id
    Apartment.find(user)
  end
end
