class User < ApplicationRecord
  ## Deviseの機能を利用
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーション（必須項目）
  validates :first_name, :last_name, :birthday, :blood_type, :address, presence: true
  validates :phone_number, presence: true, uniqueness: true,
                           format: { with: /\A\d{10,11}\z/ }

  # ひらがなのみ許可
  validates :first_name_furigana, :last_name_furigana, presence: true,
                                                       format: { with: /\A[ぁ-んー]+\z/ }

  # 血液型の選択肢
  validates :blood_type, inclusion: { in: %w[A B O AB] }

  # メールアドレスの一意性 & フォーマットチェック
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  # パスワードのバリデーション（英数字混合、6文字以上）
  validates :password, length: { minimum: 6 },
                       format: { with: /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/ }, on: :create
  validates :password_confirmation, presence: true, on: :create

  # パスワードと確認が一致するかチェック
  validate :passwords_match

  private

  def passwords_match
    return unless password.present? && password_confirmation.present? && password != password_confirmation

    errors.add(:password_confirmation)
  end
end
