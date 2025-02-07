class CreateViewAccesses < ActiveRecord::Migration[7.1]
  def change
    create_table :view_accesses do |t|
      t.references :user, null: false, foreign_key: true  # B（URL取得者）
      t.references :parent, null: false, foreign_key: { to_table: :users } # A（公開ページ所有者）
      t.string :public_page_url, null: true  # Aの公開ページURL（Bが取得したもの）
      t.datetime :last_accessed_at, null: true  # BがAのページを最後に閲覧した日時
      t.integer :access_count, null: false, default: 0  # BがAのページを閲覧した回数

      t.timestamps
    end
  end
end