class ViewRequest < ApplicationRecord
  belongs_to :viewer, class_name: 'User'
  belongs_to :owner, class_name: 'User', optional: true # 公開者（owner）を追加

  validates :first_name, presence: true
  validates :first_name_furigana, presence: true
  validates :last_name, presence: true
  validates :last_name_furigana, presence: true
  validates :birthday, presence: true
  validates :blood_type, presence: true
  validates :relationship, presence: true

  validate :unique_combination

  # <!-- 追記開始 --> `before_save` で `owner_id` を自動設定
  before_save :set_owner_id
  # <!-- 追記終了 -->

  # ✅ `users` テーブルの情報と一致するユーザーを検索
  def matching_user
    User.where(
      first_name: first_name,
      first_name_furigana: first_name_furigana,
      last_name: last_name,
      last_name_furigana: last_name_furigana,
      birthday: birthday,
      blood_type: blood_type
    ).order(:id).first # 先頭のユーザーを取得
  end

  private

  # <!-- 追記開始 --> `owner_id` を自動設定するメソッド
  def set_owner_id
    return unless owner_id.nil?

    matched_user = matching_user
    if matched_user.present?
      self.owner_id = matched_user.id
      Rails.logger.debug "✅ owner_id を自動設定: #{matched_user.id}"
    else
      Rails.logger.debug '⚠️ owner_id の自動設定に失敗 (該当ユーザーなし)'
    end
  end
  # <!-- 追記終了 -->

  # **同じ情報のリクエストが登録されないようにする**
  def unique_combination
    if ViewRequest.where(
      first_name: first_name,
      first_name_furigana: first_name_furigana,
      last_name: last_name,
      last_name_furigana: last_name_furigana,
      birthday: birthday,
      blood_type: blood_type,
      viewer_id: viewer_id
    ).where.not(id: id).exists?
      errors.add(:base, '同じ閲覧申請がすでに登録されています。')
    end
  end
end
