module ApplicationHelper
  require 'rqrcode'

  def generate_qr_code(url)
    qrcode = RQRCode::QRCode.new(url)
    svg = qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )
    svg.html_safe
  end
end
