class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :first_name_furigana, presence: true, format: { with: /\A[ぁ-んー]+\z/, message: 'ひらがなのみ入力してください' }
  validates :last_name, presence: true
  validates :last_name_furigana, presence: true, format: { with: /\A[ぁ-んー]+\z/, message: 'ひらがなのみ入力してください' }
  validates :birthday, presence: true
  validates :blood_type, presence: true, inclusion: { in: %w[A B O AB] }
  validates :address, presence: true
  validates :phone_number, presence: true, uniqueness: true,
                           format: { with: /\A\d{10,11}\z/, message: '10桁または11桁の半角数字を入力してください' }
end
