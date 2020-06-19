class Building < ApplicationRecord
  belongs_to :user
  has_many :apartments, dependent: :destroy
  has_many :rooms, dependent: :destroy
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
    "#{self.address} #{self.address_number}, #{self.city}/#{self.province}  #{self.country}"
  end

  def unpaid
    unpaid = 0  
    self.apartments.each do |apartment|
      orders = Order.where(apartment: apartment)
      unpaid_orders = orders.where(state: 'pending')
      unpaid_orders.each do |order|
        unpaid += order.amount_cents
      end
    end
    return unpaid/100
  end

  def unpaid_delay
    unpaid = 0  
    self.apartments.each do |apartment|
      orders = Order.where(apartment: apartment)
      unpaid_orders = orders.where(state: 'pending')
      unpaid_orders.each do |order|
        if order.created_at.to_date < Date.today
          unpaid += order.amount_cents
        end
      end
    end
    return unpaid/100
  end

  def default_rate
    unpaid = 0.0
    total = 0.0
    self.apartments.each do |apartment|
      orders = Order.where(apartment: apartment)
      orders.each do |order|
        if order.state == 'pending'
          unpaid += order.amount_cents
        end
        total += order.amount_cents
      end
    end
    index = (unpaid/total * 100).round(1)
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
      apartment.bill_cents = worksheet[i][2].value
      apartment.user_id = user.id
      apartment.save!
      i += 1
    end
  end
end