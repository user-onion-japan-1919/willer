class CreateNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :notes do |t|
      t.references :user, null: false, foreign_key: true

      t.string :type_1
      t.string :type_2
      t.string :type_3
      t.string :type_4
      t.string :type_5

      t.string :issue_1
      t.string :issue_2
      t.string :issue_3
      t.string :issue_4
      t.string :issue_5

      t.string :requirement_1
      t.string :requirement_2
      t.string :requirement_3
      t.string :requirement_4
      t.string :requirement_5

      t.string :title_1
      t.string :title_2
      t.string :title_3
      t.string :title_4
      t.string :title_5

      t.text :content_1
      t.text :content_2
      t.text :content_3
      t.text :content_4
      t.text :content_5

      t.json :metadata, null: true # ✅ default: {} を削除
      t.timestamps
    end

  end
end