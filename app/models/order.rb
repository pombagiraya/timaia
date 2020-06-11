class Order < ApplicationRecord
  belongs_to :user
  belongs_to :apartment

  monetize :amount_cents
end
