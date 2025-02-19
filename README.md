

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
has_many :view_permissions, foreign_key: :owner_id, dependent: :destroy
has_many :view_requests, foreign_key: :user_id, dependent: :destroy
has_many :view_accesses_as_owner, class_name: 'ViewAccess', foreign_key: :owner_id, dependent: :destroy
has_many :view_accesses_as_viewer, class_name: 'ViewAccess', foreign_key: :viewer_id, dependent: :destroy










## 2. view_permissions テーブル（閲覧許可情報）
| Column                   | Type       | Options                                   |
| ------------------------ | ---------- | ----------------------------------------- |
| owner_id                 | bigint     | null: false, foreign_key: { to_table: :users } |
| viewer_id                | bigint     | null: false, foreign_key: { to_table: :users } |
| first_name               | string     | null: false |
| first_name_furigana      | string     | null: false |
| last_name                | string     | null: false |
| last_name_furigana       | string     | null: false |
| birthday                 | date       | null: false |
| blood_type               | string     | null: false |

### **2. Association**
belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
belongs_to :viewer, class_name: 'User', foreign_key: 'viewer_id'










## 3. view_requests テーブル（閲覧申請情報）
| Column              | Type       | Options                                         |
| ------------------- | ---------- | ----------------------------------------------- |
| user_id             | references | null: false, foreign_key: true                 | # 閲覧者
| first_name          | string     | null: false                                    |
| first_name_furigana | string     | null: false                                    |
| last_name           | string     | null: false                                    |
| last_name_furigana  | string     | null: false                                    |
| birthday            | date       | null: false                                    |
| blood_type          | string     | null: false                                    |
| relationship        | string     | null: false                                    |

### **3. Association**
belongs_to :user










## 4. view_accesses テーブル（閲覧アクセス情報）
| Column           | Type       | Options                                         |
| ---------------- | ---------- | ----------------------------------------------- |
| owner_id         | bigint     | null: false, foreign_key: { to_table: :users }  | # 公開者
| viewer_id        | bigint     | null: false, foreign_key: { to_table: :users }  | # 閲覧者
| public_page_url  | string     | null: true                                      |
| last_accessed_at | datetime   | null: true                                      |
| access_count     | integer    | null: false, default: 0                         |
| last_rejected_at | datetime   | null: true                                      |
| rejected_count     | integer    | null: false, default: 0                       |

### **4. Association**
belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
belongs_to :viewer, class_name: 'User', foreign_key: 'viewer_id'

**✅ インデックス追加**
```ruby
add_index :view_accesses, [:owner_id, :viewer_id], unique: true
```



## 5.notes テーブル（遺言データ）
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| user_id            | references | null: false,foreign_key: true  |
| type_1             | string     | null: true                     |
| type_2             | string     | null: true                     |
| type_3             | string     | null: true                     |
| type_4             | string     | null: true                     |
| type_5             | string     | null: true                     |
| issue_1            | string     | null: true                     |
| issue_2            | string     | null: true                     |
| issue_3            | string     | null: true                     |
| issue_4            | string     | null: true                     |
| issue_5            | string     | null: true                     |
| requirement_1      | string     | null: true                     |
| requirement_2      | string     | null: true                     |
| requirement_3      | string     | null: true                     |
| requirement_4      | string     | null: true                     |
| requirement_5      | string     | null: true                     |
| title_1            | string     | null: true                     |
| title_2            | string     | null: true                     |
| title_3            | string     | null: true                     |
| title_4            | string     | null: true                     |
| title_5            | string     | null: true                     |
| content_1          | text       | null: true                     |
| content_2          | text       | null: true                     |
| content_3          | text       | null: true                     |
| content_4          | text       | null: true                     |
| content_5          | text       | null: true                     |
| metadata           | json       | null: true                     |
| created_at         | datetime   | null: false                    |
| updated_at         | datetime   | null: false                    |




### 5.Association
belongs_to :user

