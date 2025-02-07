class ViewAccess < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :viewer, class_name: 'User', foreign_key: 'viewer_id'

  validates :public_page_url, presence: true, allow_nil: true # URLはまだ取得していない可能性がある
  validates :access_count, numericality: { greater_than_or_equal_to: 0 }

  def update_access_history
    self.last_accessed_at = Time.current
    self.access_count += 1
    save
  end
end
