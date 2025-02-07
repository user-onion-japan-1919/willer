class CreateViewPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :view_permissions do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users } # 公開ページの持ち主
      t.references :viewer, null: false, foreign_key: { to_table: :users } # 許可された閲覧者

      t.timestamps
    end

    ## **同じユーザーが重複して許可されないように一意制約**
    add_index :view_permissions, [:owner_id, :viewer_id], unique: true
  end
end