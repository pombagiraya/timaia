class Apartment < ApplicationRecord
  belongs_to :building
  belongs_to :user
  has_many :payments, dependent: :destroy
  has_many :orders
  
  monetize :bill_cents

  validates :apt_number, presence: true
  validates :bill_cents, presence: true
  validates :building_id, presence: true
  validates :user_id, presence: true

  def unpaid
    unpaid = 0  
    orders = Order.where(apartment: self)
    unpaid_orders = orders.where(state: 'pending')
    unpaid_orders.each do |order|
      unpaid += order.amount_cents
    end
    return unpaid/100
  end

  def unpaid_delay
    unpaid = 0  
    orders = Order.where(apartment: self)
    unpaid_orders = orders.where(state: 'pending')
    unpaid_orders.each do |order|
      if order.created_at.to_date < Date.today
        unpaid += order.amount_cents
      end
    end
    return unpaid/100
  end

  def self.search(user)
    user = Apartment.user_id
    Apartment.find(user)
  end
end
