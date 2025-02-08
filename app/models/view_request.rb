class ViewRequest < ApplicationRecord
  belongs_to :user # 閲覧をリクエストしたユーザー（子側）
  belongs_to :parent, class_name: 'User', foreign_key: 'parent_id', optional: true # parent_id は後で確定

  validates :first_name, presence: true
  validates :first_name_furigana, presence: true
  validates :last_name, presence: true
  validates :last_name_furigana, presence: true
  validates :birthday, presence: true
  validates :blood_type, presence: true
  validates :relationship, presence: true

  validate :unique_combination

  private

  # **`parent_id` を除外し、同じ情報のリクエストが登録されないようにする**
  def unique_combination
    if ViewRequest.exists?(
      first_name: first_name,
      first_name_furigana: first_name_furigana,
      last_name: last_name,
      last_name_furigana: last_name_furigana,
      blood_type: blood_type,
      user_id: user_id # 同じ閲覧者が重複登録しないように制限
    )
      errors.add(:base, '同じ閲覧申請がすでに登録されています。')
    end
  end
end
