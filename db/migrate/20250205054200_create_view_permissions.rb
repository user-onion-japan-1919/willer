class CreateViewPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :view_permissions do |t|
      t.references :user, foreign_key: true, null: false  # 親ユーザーと紐づけ
      t.string :last_name, null: false
      t.string :last_name_furigana, null: false
      t.string :first_name, null: false
      t.string :first_name_furigana, null: false
      t.date :birthday, null: false
      t.string :blood_type, null: false

      t.timestamps
    end
  end
end