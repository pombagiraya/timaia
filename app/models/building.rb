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

  def unpaid
    unpaid = 0
    self.apartments.each do |apartment|
      apartment.payments.each do |payment|
        if payment.status == 0
          unpaid += apartment.bill
        end
      end
    end
    return unpaid
  end

  def unpaid_delay
    unpaid_delay = 0
    self.apartments.each do |apartment|
      apartment.payments.each do |payment|
        if payment.status == 0 && payment.payment_date <= Date.today
          unpaid_delay += apartment.bill
        end
      end
    end
    return unpaid_delay
  end

  def default_rate
    default_rate = 0
    self.apartments.each do |apartment|
      apto_unpaid = 0
      apartment.payments.each do |payment|
        if payment.status == 0
          apto_unpaid += apartment.bill
        end
      end
      default_rate += 1 if apto_unpaid > 0
    end
    return (default_rate*1.00 / self.apartments.count*1.00)* 100.0
  end
end