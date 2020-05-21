class Payment < ApplicationRecord
  belongs_to :apartment

  validates :payment_date, presence: true
  validates :status, presence: true
  validates :apartment_id, presence: true
end
