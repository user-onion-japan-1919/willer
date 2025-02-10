class CreateNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :notes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.json :metadata, null: true # ✅ default: {} を削除
      t.timestamps
    end
  end
end