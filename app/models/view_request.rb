class ViewRequest < ApplicationRecord
  belongs_to :user # 閲覧申請をしたユーザー（子側）
  belongs_to :parent, class_name: 'User' # 閲覧対象のユーザー（親側）

  validates :viewer_email, presence: true
  validates :viewer_phone_number, presence: true
end
