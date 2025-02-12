require 'prawn'

class NotePdf < Prawn::Document
  def initialize(note)
    super()
    text "ノートのタイトル: #{note.title}", size: 20, style: :bold
    move_down 10
    text "内容:\n#{note.content}", size: 14
  end
end
