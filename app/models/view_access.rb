class ViewAccess < ApplicationRecord
  belongs_to :user # B（URL取得者）
  belongs_to :parent, class_name: 'User', foreign_key: 'parent_id' # A（公開ページ所有者）

  validates :public_page_url, presence: true, allow_nil: true # URLはまだ取得していない可能性がある
  validates :access_count, numericality: { greater_than_or_equal_to: 0 }

  def update_access_history
    self.last_accessed_at = Time.current
    self.access_count += 1
    save
  end
end
