

# テーブル設計

## users テーブル（ユーザー情報）
| Column                        | Type   | Options     |
| ----------------------------- | ------ | ----------- |
| email                         | string | null: false, unique: true |
| encrypted_password            | string | null: false |
| first_name                    | string | null: false |
| first_name_furigana           | string | null: false |
| last_name                     | string | null: false |
| last_name_furigana            | string | null: false |
| birthday                      | date   | null: false |
| blood_type                    | string | null: false |
| address                       | string | null: false |
| phone_number                  | string | null: false, unique: true |

### Association
has_many :notes
has_many :view_permissions
has_many :view_requests
has_many :note_assistances






## notes テーブル（遺言データ）
| Column             | Type       | Options     |
| ------------------ | ---------- | ----------- |
| user               | references | null: false,foreign_key: true |
| content            | text       | null: false |    ## 遺言の内容

### Association
belongs_to :user
has_many :note_assistances








## view_permissions テーブル（閲覧許可情報）
| Column                       | Type       | Options     |
| ---------------------------- | ---------- | ----------- |
| user                         | references | null: false,foreign_key: true |
| first_name                   | string     | null: false |
| first_name_furigana          | string     | null: false |
| last_name                    | string     | null: false |
| last_name_furigana           | string     | null: false |
| birthday                     | date       | null: false |
| blood_type                   | string     | null: false |



### Association
belongs_to :user



## view_requests テーブル（閲覧申請情報）
| Column              | Type       | Options     |
| ------------------- | ---------- | ----------- |
| user                | references | null: false, foreign_key: true | 
| parent_id           | bigint     | null: false, foreign_key: true  |  # 閲覧される者(親側)
| first_name          | string     | null: false |
| first_name_furigana | string     | null: false |
| last_name           | string     | null: false |
| last_name_furigana  | string     | null: false |
| birthday            | date       | null: false |
| blood_type          | string     | null: false |



### Association
belongs_to :user
belongs_to :parent, class_name: 'User', foreign_key: 'parent_id'





## note_assistances テーブル（記述サポート情報）
| Column              | Type       | Options     |
| ------------------- | ---------- | ----------- |
| user                | references | null: false,foreign_key: true |
| note                | references | null: false,foreign_key: true |
| guidance            | text       | null: false |    ## 記述サポート情報

### Association
belongs_to :user
belongs_to :note