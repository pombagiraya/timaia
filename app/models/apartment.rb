class Apartment < ApplicationRecord
  belongs_to :building
  belongs_to :user
  has_many :payments, dependent: :destroy

  validates :apt_number, presence: true
  validates :bill, presence: true
  validates :building_id, presence: true
  validates :user_id, presence: true

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ['Building', 'Apto Number', 'Bill ($)', 'Owner Name', 'Owner E-mail']
      all.each do |apartment|
        csv << [apartment.building.building_name, apartment.apt_number, apartment.bill, apartment.user.name, apartment.user.email ]
      end
    end
  end

  def unpaid
    unpaid = 0
    self.payments.each do |payment|
      if payment.status == 0
        unpaid += 1
      end
    end
    unpaid *= self.bill
    return unpaid
  end

  def unpaid_delay
    unpaid_delay = 0
    self.payments.each do |payment|
      if payment.status == 0 && payment.payment_date <= Date.today
        unpaid_delay += 1
      end
    end
    unpaid_delay *= self.bill
    return unpaid_delay
  end

  def self.search(user)
    user = Apartment.user_id
    Apartment.find(user)
  end
end
