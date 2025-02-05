class ViewRequest < ApplicationRecord
  belongs_to :user # 閲覧をリクエストしたユーザー（子側）
  belongs_to :parent, class_name: 'User', foreign_key: 'parent_id' # 閲覧される対象者（親側）

  validates :viewer_first_name, presence: true
  validates :viewer_first_name_furigana, presence: true
  validates :viewer_last_name, presence: true
  validates :viewer_last_name_furigana, presence: true
  validates :relationship, presence: true
  validates :viewer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :viewer_birthday, presence: true
  validates :viewer_blood_type, presence: true
  validates :viewer_address, presence: true
  validates :viewer_phone_number, presence: true, uniqueness: true
end
