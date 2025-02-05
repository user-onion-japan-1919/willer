

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
| note                         | references | null: false,foreign_key: true |
| viewer_first_name            | string     | null: false |
| viewer_first_name_furigana   | string     | null: false |
| viewer_last_name             | string     | null: false |
| viewer_last_name_furigana    | string     | null: false |
| relationship                 | string     | null: false |    ## 続柄
| viewer_email                 | string     | null: false, unique: true |
| viewer_birthday              | date       | null: false |
| viewer_blood_type            | string     | null: false |
| viewer_address               | string     | null: false |
| viewer_phone_number          | string     | null: false, unique: true |


### Association
belongs_to :user
belongs_to :note



## view_requests テーブル（閲覧申請情報）
| Column                       | Type       | Options     |
| ---------------------------- | ---------- | ----------- |
| user                         | references | null: false, foreign_key: true | 
| parent_id                    | bigint     | null: false, foreign_key: true |
| viewer_first_name            | string     | null: false |
| viewer_first_name_furigana   | string     | null: false |
| viewer_last_name             | string     | null: false |
| viewer_last_name_furigana    | string     | null: false |
| relationship                 | string     | null: false |    ## 続柄
| viewer_email                 | string     | null: false |
| viewer_birthday              | date       | null: false |
| viewer_blood_type            | string     | null: false |
| viewer_address               | string     | null: false |
| viewer_phone_number          | string     | null: false |


### Association
belongs_to :user
belongs_to :parent, class_name: 'User'





## note_assistances テーブル（記述サポート情報）
| Column              | Type       | Options     |
| ------------------- | ---------- | ----------- |
| user                | references | null: false,foreign_key: true |
| note                | references | null: false,foreign_key: true |
| guidance            | text       | null: false |    ## 記述サポート情報

### Association
belongs_to :user
belongs_to :note