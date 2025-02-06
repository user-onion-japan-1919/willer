class ViewPermission < ApplicationRecord
  belongs_to :user

  validates :first_name, presence: true
  validates :first_name_furigana, presence: true
  validates :last_name, presence: true
  validates :last_name_furigana, presence: true
  validates :birthday, presence: true
  validates :blood_type, presence: true

  validate :unique_combination

  private

  def unique_combination
    if ViewPermission.exists?(
      first_name: first_name,
      first_name_furigana: first_name_furigana,
      last_name: last_name,
      last_name_furigana: last_name_furigana,
      blood_type: blood_type,
      user_id: user_id # 同じユーザーが重複登録しないように制限
    )
      errors.add(:base, 'この閲覧許可対象者はすでに登録されています。')
    end
  end
end
