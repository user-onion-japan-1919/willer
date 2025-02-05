class ViewRequest < ApplicationRecord
  belongs_to :user # 閲覧申請をしたユーザー（子側）
  belongs_to :parent, class_name: 'User', foreign_key: 'parent_id'

  validates :viewer_email, presence: true
  validates :viewer_phone_number, presence: true
end
