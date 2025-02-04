class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :first_name, null: false
      t.string :first_name_furigana, null: false
      t.string :last_name, null: false
      t.string :last_name_furigana, null: false
      t.date   :birthday, null: false
      t.string :blood_type, null: false
      t.string :address, null: false
      t.string :phone_number, null: false
    end
    add_index :users, :phone_number, unique: true  # 一意性制約を追加
  end
end