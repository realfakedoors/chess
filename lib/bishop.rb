require_relative 'piece.rb'

class Bishop < Piece
  
  def initialize(color)
    @color = color
    @type = "Bishop"
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