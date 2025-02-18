# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## ユーザー情報
      t.string :first_name, null: false
      t.string :first_name_furigana, null: false
      t.string :last_name, null: false
      t.string :last_name_furigana, null: false
      t.date   :birthday, null: false
      t.string :blood_type, null: false
      t.string :address, null: false
      t.string :phone_number, null: false
      t.string :uuid, null: false


 ## ✅ ログアウト時刻を記録するカラムを追加
 t.datetime :last_logout_at, null: true


      t.timestamps null: false
    end

    ## インデックス
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :phone_number, unique: true  # 一意性制約
    add_index :users, :uuid, unique: true  # UUIDを一意にする

## **複合ユニークインデックス（6つの情報が一致するユーザーを禁止）**
add_index :users, [:first_name, :last_name, :first_name_furigana, :last_name_furigana, :birthday, :blood_type], unique: true, name: "index_users_on_unique_personal_info", length: { first_name: 100, last_name: 100, first_name_furigana: 100, last_name_furigana: 100, blood_type: 10 }
  end
end