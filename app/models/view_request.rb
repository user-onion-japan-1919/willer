class ViewRequest < ApplicationRecord
  belongs_to :user # 閲覧をリクエストしたユーザー（子側）
  belongs_to :parent, class_name: 'User', foreign_key: 'parent_id' # 閲覧される対象者（親側）

  validates :first_name, presence: true
  validates :first_name_furigana, presence: true
  validates :last_name, presence: true
  validates :last_name_furigana, presence: true
  validates :birthday, presence: true
  validates :blood_type, presence: true
end
