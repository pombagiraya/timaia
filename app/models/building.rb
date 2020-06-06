class Building < ApplicationRecord
  belongs_to :user
  has_many :apartments, dependent: :destroy
  geocoded_by :full_address
  after_validation :geocode, if: :will_save_change_to_address?
  has_one_attached :photo

  validates :building_name, presence: true, length: {minimum: 2}
  validates :super_name, presence: true, length: {minimum: 2}
  validates :super_email, presence: true, length: {minimum: 3}
  validates :zipcode, presence: true
  validates :address, presence: true, length: {minimum: 3}
  validates :address_number, presence: true
  validates :city, presence: true, length: {minimum: 2}
  validates :province, presence: true, length: { is: 2 }
  validates :country, presence: true, length: {minimum: 2}
  validates :user_id, presence: true
  validates :photo, presence: true

  def full_address
    "#{self.address} #{self.address_number}, #{self.zipcode}, #{self.city}/#{self.province}  #{self.country}"
  end

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
    index = ((default_rate*1.00 / self.apartments.count*1.00)* 100.0).round(1)
    return index.to_f.nan? ? 0.0 : index 
  end

  def self.import(file)
    workbook = RubyXL::Parser.parse(file)
    worksheet = workbook[0]
    rowCount = worksheet.sheet_data.rows.size
    i = 1
    (rowCount -1).times do
      user = User.where(email: worksheet[i][4].value).first
      if user.nil?
        user = User.new
        user.email = worksheet[i][4].value
        user.name = worksheet[i][3].value
        user.password = '123456'
        user.role = 0
        user.save!
      end
      apartment = Apartment.where(apt_number: worksheet[i][1].value).where(building: Building.where(building_name: worksheet[i][0].value)).first
      apartment = Apartment.new if apartment.nil?
      apartment.apt_number = worksheet[i][1].value
      apartment.building_id = Building.where(building_name: worksheet[i][0].value).first.id
      apartment.bill = worksheet[i][2].value
      apartment.user_id = user.id
      apartment.save!
      i += 1
    end
  end
end