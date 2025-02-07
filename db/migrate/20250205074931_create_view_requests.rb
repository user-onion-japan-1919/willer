class CreateViewRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :view_requests do |t|
      t.references :user, null: false, foreign_key: true  # 閲覧をリクエストしたユーザー（子側）
      t.references :parent, null: false, foreign_key: { to_table: :users } # 閲覧される親ユーザー

      t.string :first_name, null: false
      t.string :first_name_furigana, null: false
      t.string :last_name, null: false
      t.string :last_name_furigana, null: false
      t.date :birthday, null: false
      t.string :blood_type, null: false
      t.string :relationship, null: false

      t.timestamps
    end

    ## **同じ親に対する重複リクエストを防ぐための一意制約**
    add_index :view_requests, [:user_id, :parent_id], unique: true
  end
end