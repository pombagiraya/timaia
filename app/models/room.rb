class Room < ApplicationRecord
  belongs_to :building
  has_many :schedules, dependent: :destroy
end
