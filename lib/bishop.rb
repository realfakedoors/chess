require_relative 'piece.rb'

class Bishop < Piece
  
  def initialize(color)
    @color = color
    @type = "Bishop"
  end
  
  def get_right_diags(column, row)
    opposite_row = row
    right_diags = []

    column.upto("h") do |col|
      next if col == column
      row += 1
      opposite_row -= 1
      unless row > 8
        right_diags << "#{col}#{row}"
      end
      unless opposite_row < 1
        right_diags << "#{col}#{opposite_row}"
      end
      break if row == 8
    end
    right_diags
  end

  def get_left_diags(column, row)
    opposite_row = row
    left_diags = []

    (column.ord).downto("a".ord) do |col|
      col = col.chr
      next if col == column
      row -= 1
      opposite_row += 1
      unless row < 1
        left_diags << "#{col}#{row}"
      end
      unless opposite_row > 8
        left_diags << "#{col}#{opposite_row}"
      end
    end
    left_diags
  end

  def possible_moves
    moves = []

    column = self.get_column
    row = self.get_row

    moves << get_right_diags(column, row)
    moves << get_left_diags(column, row)
    moves.flatten!
  end
  
  def display
    if @color == "white"
      "\u265D"
    elsif @color == "black"
      "\u2657"
    end
  end
  
end