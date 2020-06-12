class Room < ApplicationRecord
  belongs_to :building
  has_many :schedules, dependent: :destroy

  validates :price, presence: true
  validates :name, presence: true
  validates :building_id, presence: true
end
