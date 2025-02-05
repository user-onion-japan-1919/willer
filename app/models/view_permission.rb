class ViewPermission < ApplicationRecord
  belongs_to :user

  validates :last_name, :last_name_furigana, :first_name, :first_name_furigana, :birthday, :blood_type, presence: true
end
