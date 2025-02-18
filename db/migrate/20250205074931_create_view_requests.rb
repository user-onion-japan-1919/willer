class CreateViewRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :view_requests do |t|
      t.references :viewer, null: false, foreign_key: { to_table: :users }  # 閲覧をリクエストしたユーザー（子側）
      t.references :owner, null: true, foreign_key: { to_table: :users }    # 公開者（親側）, 空でもOK

      t.string :first_name, null: false
      t.string :first_name_furigana, null: false
      t.string :last_name, null: false
      t.string :last_name_furigana, null: false
      t.date :birthday, null: false
      t.string :blood_type, null: false
      t.string :relationship, null: false
      t.string :url, null: true
      t.timestamps
    end
  end
end