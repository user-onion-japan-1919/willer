WickedPdf.configure do |config|
  if Rails.env.production?
    config.exe_path = '/usr/bin/wkhtmltopdf' # 本番環境のパス（Render用）
  else
    config.exe_path = '/Users/takasakashuta/.rbenv/shims/wkhtmltopdf' # ローカル環境のパス
  end
end