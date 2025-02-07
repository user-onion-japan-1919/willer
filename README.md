

# テーブル設計

## 1.users テーブル（ユーザー情報）
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
| uuid                          | string | null: false, unique: true |

### 1.Association
has_many :notes
has_many :view_permissions
has_many :view_requests
has_many :view_accesses
has_many :note_assistances










## 2.view_permissions テーブル（閲覧許可情報）
| Column                       | Type       | Options     |
| ---------------------------- | ---------- | ----------- |
| user                         | references | null: false,foreign_key: true |
| first_name                   | string     | null: false |
| first_name_furigana          | string     | null: false |
| last_name                    | string     | null: false |
| last_name_furigana           | string     | null: false |
| birthday                     | date       | null: false |
| blood_type                   | string     | null: false |

### 2.Association
belongs_to :user










## 3.view_requests テーブル（閲覧申請情報）
| Column              | Type       | Options     |
| ------------------- | ---------- | ----------- |
| user                | references | null: false, foreign_key: true | 
| parent_id           | bigint     | null: false, foreign_key: true | # 閲覧される側
| first_name          | string     | null: false |
| first_name_furigana | string     | null: false |
| last_name           | string     | null: false |
| last_name_furigana  | string     | null: false |
| birthday            | date       | null: false |
| blood_type          | string     | null: false |
| relationship        | string     | null: false |

### 3.Association
belongs_to :user
belongs_to :parent, class_name: 'User', foreign_key: 'parent_id'










## 4.view_accessses テーブル（閲覧申請情報）
| Column              | Type       | Options     |
| ------------------- | ---------- | ----------- |
| owner_id            | bigint     | null: false, foreign_key: true | # 公開者(1人)
| viewer_id           | bigint     | null: false, foreign_key: true | # 閲覧者(複数)
| public_page_url     | string     | null: true |
| last_accessed_at    | datetime   | null: true |
| access_count        | integer    | null: false, default: 0 |

### 4.Association
belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'  # 公開ページの持ち主
belongs_to :viewer, class_name: 'User', foreign_key: 'viewer_id' # 閲覧者










## 5.notes テーブル（遺言データ）
| Column             | Type       | Options     |
| ------------------ | ---------- | ----------- |
| user               | references | null: false,foreign_key: true |
| content            | text       | null: false |    ## 遺言の内容

### 5.Association
belongs_to :user
has_many :note_assistances

