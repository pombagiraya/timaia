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

  def self.import(file)
    workbook = RubyXL::Parser.parse(file)
    worksheet = workbook[0]
    rowCount = worksheet.sheet_data.rows.size
    i = 1
    rowCount.times do
      user = User.where(email: worksheet[i][4].value) || User.new
      if user == User.new
        user.email = worksheet[i][4].value
        user.name = worksheet[i][3].value
        user.password = '123456'
        user.role = 1
        user.save!
      end
      apartment << Apartment.where(apt_number: worksheet[i][1].value).where(building: Building.where(building_name: worksheet[i][0].value)) || Apartment.new
      apartment.apt_number = worksheet[i][1].value
      apartment.building_id = Building.where(name: worksheet[i][0].value).id
      apartment.bill = worksheet[i][2].value
      apartment.user_id = user_id
      apartment.save!
      i += 1
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

  private
end
