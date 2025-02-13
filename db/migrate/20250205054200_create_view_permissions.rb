class CreateViewPermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :view_permissions do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users } # 公開ページの持ち主
      t.references :viewer, null: true, foreign_key: { to_table: :users } # 許可された閲覧者

      # 許可された閲覧者の情報（検索・認証用）
      t.string :first_name, null: false
      t.string :first_name_furigana, null: false
      t.string :last_name, null: false
      t.string :last_name_furigana, null: false
      t.date :birthday, null: false
      t.string :blood_type, null: false

       # ✅ ON/OFFスイッチ（デフォルトはON）
       t.boolean :on_off, null: false, default: true

       # ✅ タイマー機能（ON に戻るまでの時間を分単位で保存）
       t.integer :on_timer_minutes, default: 30, null: false

      t.timestamps
    end

    ## **同じユーザーが重複して許可されないように一意制約**
    add_index :view_permissions, [:owner_id, :viewer_id], unique: true
  end
end