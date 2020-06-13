class Apartment < ApplicationRecord
  belongs_to :building
  belongs_to :user
  has_many :payments, dependent: :destroy
  has_many :orders
  
  # monetize :bill_cents

  validates :apt_number, presence: true
  validates :bill_cents, presence: true
  validates :building_id, presence: true
  validates :user_id, presence: true

  def unpaid
    unpaid = 0
    self.payments.each do |payment|
      if payment.status == 0
        unpaid += 1
      end
    end
    unpaid *= self.bill_cents
    return unpaid
  end

  def unpaid_delay
    unpaid_delay = 0
    self.payments.each do |payment|
      if payment.status == 0 && payment.payment_date <= Date.today
        unpaid_delay += 1
      end
    end
    unpaid_delay *= self.bill_cents
    return unpaid_delay
  end

  def self.search(user)
    user = Apartment.user_id
    Apartment.find(user)
  end
end
