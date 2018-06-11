require_relative 'piece.rb'

class Queen < Piece
  
  def initialize(color)
    @color = color
  end

  def possible_moves
    moves = []

    column = self.get_column
    row = self.get_row

    moves << get_right_diags(column, row)
    moves << get_left_diags(column, row)
    moves << get_verticals(column, row)
    moves << get_horizontals(column, row)
    moves.flatten!
  end
  
  def display
    if @color == "white"
      "\u265B"
    elsif @color == "black"
      "\u2655"
    end
  end
  
end