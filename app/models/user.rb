class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :first_name_furigana, :last_name_furigana, presence: true
  validates :birthday, :blood_type, :address, :phone_number, presence: true
  validates :phone_number, uniqueness: true, format: { with: /\A\d{10,11}\z/ }
end
