source "https://rubygems.org"

ruby "3.2.0"

# フレームワーク
gem "rails", "~> 7.1.0"

# データベース
gem "mysql2", "~> 0.5"       # 開発環境
gem "pg", group: :production # 本番環境

# サーバー
gem "puma", ">= 5.0"

# フロントエンド
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "rqrcode"
gem "wicked_pdf", "~> 2.8"
gem "wkhtmltopdf-binary", "~> 0.12.6"
gem "bootstrap"
gem "actioncable"

gem 'sassc-rails'
gem 'uglifier' # JavaScriptの圧縮用（必要なら）

# バックエンド
gem "devise", "~> 4.9"
gem "sidekiq"
gem "whenever", require: false
gem "prawn"
gem "prawn-table"

# パフォーマンス最適化
gem "bootsnap", require: false

# 環境変数管理
gem "dotenv-rails" # ✅ 環境変数用に追記

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails"
  gem "factory_bot_rails" # ✅ テストデータ生成用に追記
  gem "shoulda-matchers"
  gem "rubocop", require: false
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

# Sidekiq用にRedisを有効化
gem "redis", ">= 4.0.1"