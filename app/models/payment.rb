class Payment < ApplicationRecord
  belongs_to :apartment
  has_many :orders

  validates :payment_date, presence: true
  validates :status, presence: true
  validates :apartment_id, presence: true

  def deadline
    if self.payment_date > Date.today
      return 'On time'
    else
      return 'Overdue'
    end
  end

  def paid
    case self.status
    when 0 then 'Unpaid'
    when 1 then 'Paid'
    end
  end
end
