require_relative 'piece.rb'

class Rook < Piece
  
  def initialize(color)
    @color = color
  end
  
  public

  def possible_moves
    moves = []

    column = self.get_column
    row = self.get_row

    moves << get_verticals(column, row)
    moves << get_horizontals(column, row)
    moves.flatten!
  end
  
  def display
    if @color == "white"
      "\u265C"
    elsif @color == "black"
      "\u2656"
    end
  end
  
end