class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :buildings
  has_many :apartments

  has_many :payments
  has_many :orders

  has_many :schedules
  has_one_attached :photo

end
