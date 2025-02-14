class ViewAccess < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :viewer, class_name: 'User', foreign_key: 'viewer_id'

  validates :public_page_url, presence: true, allow_nil: true # URLはまだ取得していない可能性がある
  validates :access_count, numericality: { greater_than_or_equal_to: 0 }

  # アクセス時のバリデーション追加(両方０はありえない)
  validates :access_count, presence: true, if: -> { rejected_count.nil? || rejected_count.zero? }
  validates :rejected_count, presence: true, if: -> { access_count.nil? || access_count.zero? }

  def update_access_history
    self.last_accessed_at = Time.current
    self.access_count += 1
    save
  end
end
