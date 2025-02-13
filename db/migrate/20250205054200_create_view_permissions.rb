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

          # ✅ ON/OFF モード（0: 常にOFF, 1: 常にON, 2: タイマーON）
      t.integer :on_mode, null: false, default: 1

      # ✅ タイマー機能（秒・分・時間・日・月・年 をサポート）
      t.integer :on_timer_value, null: false, default: 1
      t.string :on_timer_unit, null: false, default: "day" # "second", "minute", "hour", "day", "month", "year"

      # ✅ 最終ログアウト時刻（ONに戻すトリガー用）
      t.datetime :last_logout_at, default: nil

      t.timestamps
    end


    ## **同じユーザーが重複して許可されないように一意制約**
    add_index :view_permissions, [:owner_id, :viewer_id], unique: true
  end
end