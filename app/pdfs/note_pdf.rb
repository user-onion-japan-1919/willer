require 'prawn'
require 'prawn/table'

class NotePdf < Prawn::Document
  def initialize(note)
    super()

    # ✅ 日本語フォントを正しく登録
    font_path = Rails.root.join('app/assets/fonts/ipaexg.ttf')

    font_families.update(
      'IPAex' => {
        normal: font_path,
        bold: font_path
      }
    )

    font 'IPAex' # ✅ フォントを適用

    @note = note
    header
    content
  end

  def header
    text 'ノート情報', size: 18, style: :bold
  end

  def content
    move_down 10
    text "タイトル: #{@note.title_1}", size: 14, style: :bold
    move_down 5
    text "内容:\n#{@note.content_1}", size: 12
  end
end
