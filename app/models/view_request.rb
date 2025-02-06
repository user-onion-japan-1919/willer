class ViewRequest < ApplicationRecord
  belongs_to :user # 閲覧をリクエストしたユーザー（子側）
  belongs_to :parent, class_name: 'User', foreign_key: 'parent_id' # 閲覧される対象者（親側）

  validates :first_name, presence: true
  validates :first_name_furigana, presence: true
  validates :last_name, presence: true
  validates :last_name_furigana, presence: true
  validates :birthday, presence: true
  validates :blood_type, presence: true
  validates :relationship, presence: true

  validate :unique_combination

  # **アクセス履歴の更新**
  def update_access_history
    self.last_accessed_at = Time.current
    self.access_count += 1
    save
  end

  private

  # **同じ親に対する重複リクエストを防ぐ**
  def unique_combination
    if ViewRequest.exists?(
      first_name: first_name,
      first_name_furigana: first_name_furigana,
      last_name: last_name,
      last_name_furigana: last_name_furigana,
      blood_type: blood_type,
      parent_id: parent_id
    )
      errors.add(:base, '同じ名前・血液型のユーザーがすでに登録されています。')
    end
  end
end
