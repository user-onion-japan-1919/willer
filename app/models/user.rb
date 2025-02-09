class User < ApplicationRecord
  has_many :view_permissions, foreign_key: :owner_id, class_name: 'ViewPermission', dependent: :destroy
  has_many :view_requests, foreign_key: :user_id, class_name: 'ViewRequest', dependent: :destroy

  has_many :view_accesses_as_owner, class_name: 'ViewAccess', foreign_key: 'owner_id', dependent: :destroy
  has_many :view_accesses_as_viewer, class_name: 'ViewAccess', foreign_key: 'viewer_id', dependent: :destroy

  has_many :notes, dependent: :destroy

  ## Deviseの機能を利用
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # メールアドレスの一意性 & フォーマットチェック
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  # パスワードのバリデーション（英数字混合、6文字以上）
  validates :password, length: { minimum: 6 },
                       format: { with: /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/ }, on: :create
  validates :password_confirmation, presence: true, on: :create

  # パスワードと確認が一致するかチェック
  validate :passwords_match

  # 名前（漢字・カナ）のバリデーション
  validates :first_name, presence: true
  validates :first_name_furigana, presence: true, format: { with: /\A[ぁ-んー]+\z/ }

  validates :last_name, presence: true
  validates :last_name_furigana, presence: true, format: { with: /\A[ぁ-んー]+\z/ }

  # 生年月日
  validates :birthday, presence: true

  # 血液型の選択肢
  validates :blood_type, presence: true, inclusion: { in: %w[A B O AB] }

  # 住所
  validates :address, presence: true

  # 電話番号（10桁または11桁の半角数字）
  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A\d{10,11}\z/ }

  # **UUID の自動生成**
  before_create :set_uuid

  private

  def passwords_match
    return unless password.present? && password_confirmation.present? && password != password_confirmation
  end

  # **UUID を自動生成**
  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
