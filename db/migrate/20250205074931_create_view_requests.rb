class CreateViewRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :view_requests do |t|
      t.references :user, null: false, foreign_key: true  # 閲覧をリクエストしたユーザー（子側）
      t.bigint :parent_id, null: false
      t.foreign_key :users, column: :parent_id  
      t.string :viewer_first_name, null: false
      t.string :viewer_first_name_furigana, null: false
      t.string :viewer_last_name, null: false
      t.string :viewer_last_name_furigana, null: false
      t.string :relationship, null: false  # 続柄.
      t.string :viewer_email, null: false
      t.date :viewer_birthday, null: false
      t.string :viewer_blood_type, null: false
      t.string :viewer_address, null: false
      t.string :viewer_phone_number, null: false

      t.timestamps
    end
  end
end