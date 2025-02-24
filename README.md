

## アプリケーション名
　遺言の作成/管理/共有 - Will_Note -  📓　　（ウィルノート）<br><br>



## アプリケーション概要
・親側：遺言の言語化と作成をサポートし、子に記録を遺す。<br>
・子側：必要時に親側の情報を検索し、”親の意思を尊重した遺言執行”をサポート。<br><br>



## 開発環境
・本番アップロード先　（Render）<br>
・タスク管理　（GitHub）<br>
・テキストエディタ　（VS Code）<br><br>

・本番環境データベース（PostgreSQL）<br>
・開発環境データベース（MySQL）<br>
・プログラミング言語　（JavaScript・Ruby3.2.0・SQL系）<br>
・マークアップ・スタイル言語　（HTML・CSS・ERB）<br>

ーーーーーーーーーー<br>

・フロントエンド　（JavaScript・HTML・CSS・RQRCode・Wicked PDF・Bootstrap・actioncable）<br>
・インフラ　（PostgreSQL・MySQL・Redis）<br>
・バックエンド　（Ruby on Rails 7.1.0・Sidekiq・Whenever・Prawn・Prawn-Table）<br>
・テスト　（RSpec・Rubocop・FactoryBot・Capybara）<br>
・パフォーマンス最適化　（Bootsnap・shoulda-matchers・dotenv-rails）<br><br>



## URL
　https://willer.onrender.com <br><br>

・Basic認証ID：admin<br>
・Basic認証パスワード：2222<br><br>



## テスト用アカウント
・テスト用アドレス１（本人）：test＠testA<br>
・テスト用アドレス２（実父）：test＠testB<br>
・テスト用アドレス３（実母）：test＠testC<br>
・テスト用アドレス４（祖父）：test＠testD<br>
・テスト用アドレス５（叔父）：test＠testE<br>
・テスト用アドレス６（長男）：test＠testF<br>
・テスト用アドレス７（二女）：test＠testG<br>
・テスト用アドレス８（他人）：test＠testH<br><br>

・パスワード：admin2222　（共通）<br>
　※ログインしてご使用ください。<br><br>



## 利用方法
親側：①新規登録　②遺言情報を記入　③指定した子の閲覧を許可<br>
子側：①新規登録　②指定した親を検索　③親の遺言を管理・執行<br><br>



## アプリケーションを作成した背景
親側：いつかはやってくる自分の命日。”終活”という言葉を最近耳にするが、結局、何から始めたらいいか分からない。<br>
　　　一度子と話さなればいけないと思っているが、機会が作れない。仮に会えたとしても、内容が繊細で話しづらい。<br><br>

子側：いつかはやってくる家族の命日。”喪主や遺族代表者”になったら、何をしたらいいのだろうか？<br>
　　　一度親と話さなければいけないと思っているが、時間が取れない。仮に会えてたとしても、死後の話など直接聞きづらい。<br>
　　　そもそも、今自分にできる親孝行って、何なんだろう？　直接聞くのはちょっと野暮。<br><br>

　→そんな社会問題・ディスコミュニケーションを解決すべく、親子をつなぐ『仲介』としての手段が必要と考えた。<br>
　→チャット機能も直接対面で話す機能もないが、それでも親子の意思疎通が取れる。そんな終活補助アプリを目指した。<br><br>


## 工夫したポイント
・ユーザーの現実的・実用的なニーズに沿った設計を実装<br>
　　→恐らく、親と子ではアプリの利用時期が異なる。そのタイムラグをあらかじめ考慮し、”いつ始めても使用者に利がある”よう設計。<br>
・シンプルかつ実用的な機能のみ採用<br>
　　→要件を成すための必要な機能を取捨選択し、必要最小限だけをシンプルに実装。<br><br>



## 改善点
・”今後の実装予定”に記載したセキュリティ対策関連の実装<br>
・CSSのデザイン改良<br>
・ボタン入力時の確認メッセージ・エラーメッセージの改良<br>
・リストの表示・非表示の管理<br>
・開発者問合せ先の実装<br><br>



## 今後実装予定の機能　（セキュリティ面）
①公開ページURLの非表示化（iframe）<br>
　→URLの非表示により、SNSでの拡散を防ぐ<br><br>
 
②NOTESテーブルの暗号化（ビュー表示は可能なまま）<br>
　→管理者がノートの内容を見られないようにする<br><br>
 
③マイナンバー認証機能（JPKI）の申請と導入<br>
　→匿名・偽証でのアカウント作成を防ぎ、ログインユーザーが間違いなく本人であることを担保する<br><br>



## 制作時間
・約３週間　(令和7年 2/1〜2/21)　25/02/21本番環境1回目提出<br>
 ※ 以降も継続改良中<br><br>

<br>
<br>
<br>
<br>
<br>

## ターゲット層・差別化・目指すゴール（以下、画像説明）
<br><br>

![ターゲット1.png](./app/assets/images/ターゲット1.png)

<br>
<hr>


![ターゲット2.png](./app/assets/images/ターゲット2.png)

<br>
<hr>


![差別化.png](./app/assets/images/差別化.png)

<br>
<hr>


![セキュリティ.png](./app/assets/images/セキュリティ.png)

<br>
<hr>


![マイナポータル.png](./app/assets/images/マイナポータル.png)

<br>
<hr>



## テーブル設計図・画面
<br><br>

![オリアプ設計図.png](./app/assets/images/オリアプ_テーブル設計図.png)

<br>
<hr>


![オリアプ画面遷移図.png](./app/assets/images/オリアプ_画面遷移図.png)

<br>
<hr>



## アプリの操作画面
<br><br>

![ログインページ.png](./app/assets/images/ログインページ.png)

<br>
<hr>


![マイページ.png](./app/assets/images/マイページ.png)

<br>
<hr>


![ノート画面.png](./app/assets/images/ノート画面.png)

<br>
<hr>


![公開ページPDF.png](./app/assets/images/公開ページPDF.png)

<br>
<hr>





<br>
<br>
<br>
<br>
<br>



ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

<br>
<br>
<br>
<br>
<br>









# テーブル設計の詳細（以下、カラム一覧）
<br><br>

## 1.users テーブル（ユーザー情報）
| Column                        | Type   | Options     |
| ----------------------------- | ------ | ----------- |
| uuid                          | string | null: false, unique: true |
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
| reset_password_token          | string | null: false, unique: true |
| reset_password_sent_at        | datetime | null: true |
| remember_created_at           | datetime | null: true |
| last_logout_at                | datetime | null: true |
| created_at                    | datetime | null: false (t.timestamps) |
| updated_at                    | datetime | null: false (t.timestamps) |


### 1.Association
has_many :notes
has_many :view_permissions, foreign_key: :owner_id, dependent: :destroy
has_many :view_requests, foreign_key: :user_id, dependent: :destroy
has_many :view_accesses_as_owner, class_name: 'ViewAccess', foreign_key: :owner_id, dependent: :destroy
has_many :view_accesses_as_viewer, class_name: 'ViewAccess', foreign_key: :viewer_id, dependent: :destroy


<br>
<hr>


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
| on_mode                  | string     | null: false, default: “許可” |
| on_timer_value           | integer    | null: false, default: 1 |
| on_timer_unit            | string     | null: false, default: “day” |
| last_logout_at           | datetime   | null: true |


### **2. Association**
belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
belongs_to :viewer, class_name: 'User', foreign_key: 'viewer_id'


<br>
<hr>


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


<br>
<hr>


## 4. view_accesses テーブル（閲覧アクセス情報）
| Column           | Type       | Options                                         |
| ---------------- | ---------- | ----------------------------------------------- |
| public_page_url  | string     | null: true                                      |
| owner_id         | bigint     | null: false, foreign_key: { to_table: :users }  | # 公開者
| viewer_id        | bigint     | null: false, foreign_key: { to_table: :users }  | # 閲覧者
| last_accessed_at | datetime   | null: true                                      |
| access_count     | integer    | null: false, default: 0                         |
| last_rejected_at | datetime   | null: true                                      |
| rejected_count   | integer    | null: false, default: 0                         |


### **4. Association**
belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
belongs_to :viewer, class_name: 'User', foreign_key: 'viewer_id'


**✅ インデックス追加**
```ruby
add_index :view_accesses, [:owner_id, :viewer_id], unique: true
```


<br>
<hr>


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


### 5.Association
belongs_to :user


<br>
<hr>

