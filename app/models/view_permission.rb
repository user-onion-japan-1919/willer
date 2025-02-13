class ViewPermission < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :viewer, class_name: 'User', foreign_key: 'viewer_id', optional: true

  validates :first_name, presence: true
  validates :first_name_furigana, presence: true
  validates :last_name, presence: true
  validates :last_name_furigana, presence: true
  validates :birthday, presence: true
  validates :blood_type, presence: true

  validates :on_mode, inclusion: { in: %w[拒否 許可 タイマー] }
  validates :on_timer_value, numericality: { only_integer: true, greater_than: 0 }
  validates :on_timer_unit, inclusion: { in: %w[second minute hour day month year] }

  after_initialize :set_default_values

  validate :unique_combination, on: :create # 修正

  # ✅ ON に戻すべきか判定
  def should_reset_on?
    return false unless on_mode == 'タイマー' # "タイマー" 以外なら処理しない
    return false unless last_logout_at # 最終ログアウト時刻が記録されている場合のみ

    elapsed_time = case on_timer_unit
                   when 'second' then (Time.current - last_logout_at).to_i
                   when 'minute' then ((Time.current - last_logout_at) / 60).to_i
                   when 'hour'   then ((Time.current - last_logout_at) / 3600).to_i
                   when 'day'    then ((Time.current - last_logout_at) / 86_400).to_i
                   when 'month'  then ((Time.current - last_logout_at) / 2_592_000).to_i  # 30日換算
                   when 'year'   then ((Time.current - last_logout_at) / 31_536_000).to_i # 365日換算
                   end

    elapsed_time >= on_timer_value # 設定時間が経過したら true
  end

  # ✅ ON に戻す処理
  def reset_on_if_needed!
    return unless should_reset_on?

    update!(on_mode: '許可') # "許可" に戻す
  end

  private

  # ✅ デフォルト値の設定
  def set_default_values
    self.on_mode ||= '許可' # デフォルトで "許可"
    self.on_timer_value ||= 1
    self.on_timer_unit ||= 'day'
  end

  # ✅ 一意制約のバリデーション
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
