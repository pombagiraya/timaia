class Apartment < ApplicationRecord
  belongs_to :building
  belongs_to :user

  validates :apt_number, presence: true
  validates :bill, presence: true
  validates :building_id, presence: true
  validates :user_id, presence: true
end
