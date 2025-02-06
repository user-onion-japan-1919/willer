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

      ## UUID
      t.string :uuid, null: false

      t.timestamps null: false
    end

    ## インデックス
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :phone_number, unique: true  # 一意性制約
    add_index :users, :uuid, unique: true  # UUIDを一意にする
  end
end