require 'prawn'

class NotePdf < Prawn::Document
  def initialize(note)
    super()
    @note = note
    header
    content
  end

  def header
    text "ノートPDF", size: 20, style: :bold, align: :center
    move_down 10
  end

  def content
    text "問題: #{@note.issue_1 || '未入力'}", size: 14, style: :bold
    move_down 5
    text "タイトル: #{@note.title_1 || '未入力'}", size: 14, style: :bold
    move_down 5
    text "内容:", size: 14, style: :bold
    text @note.content_1 || '未入力', size: 12
    move_down 20

    text "問題: #{@note.issue_2 || '未入力'}", size: 14, style: :bold
    move_down 5
    text "タイトル: #{@note.title_2 || '未入力'}", size: 14, style: :bold
    move_down 5
    text "内容:", size: 14, style: :bold
    text @note.content_2 || '未入力', size: 12
  end
end