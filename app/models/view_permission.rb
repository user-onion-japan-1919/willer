class ViewPermission < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :viewer, class_name: 'User', foreign_key: 'viewer_id', optional: true

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
      birthday: birthday,
      blood_type: blood_type,
      owner_id: owner_id
    )
      errors.add(:base, 'この閲覧許可対象者はすでに登録されています。')
    end
  end
end
