class LogPdf < Prawn::Document
  def initialize(logs, userType, view)
    super(top_margin: 40)
    @logs = logs
    @type = userType
    pdf_title
    line_items
  end

  def pdf_title
    text "Logs For User : #{@type}", size: 20, style: :bold
  end

  def line_items
    move_down 10
    # table line_item_rows
    data = [["Sl No.", "Description"]] +
    @logs.select(:id, :description).map do |item|
      [item.id, item.description]
    end

    table data do
      row(0).font_style = :bold
      row(0).position = :center
      self.header = true
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.cell_style = { :inline_format => true }
    end
  end



end
