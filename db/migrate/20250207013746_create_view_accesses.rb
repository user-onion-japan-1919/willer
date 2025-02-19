class CreateViewAccesses < ActiveRecord::Migration[7.1]
  def change
    create_table :view_accesses do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users } # 公開ページの持ち主
      t.references :viewer, null: false, foreign_key: { to_table: :users } # 閲覧者

      t.string :public_page_url, null: true  # 取得した公開ページのURL

      t.datetime :last_accessed_at, null: true  # 最後にアクセスした日時
      t.integer :access_count, null: true, default: 0  # アクセス回数

      t.datetime :last_rejected_at, null: true  # 最終アクセス拒否日時
      t.integer :rejected_count, null: true, default: 0  # アクセス拒否回数


      t.timestamps
    end

    ## **同じユーザーが重複してアクセス情報を持たないようにする**
    add_index :view_accesses, [:owner_id, :viewer_id], unique: true
  end
end