require_relative 'piece.rb'

class Pawn < Piece
  
  def initialize(color)
    @color = color
    @type = "Pawn"
  end
  
  def possible_moves
    possible_moves = []
    row = self.get_row
    column = self.get_column
  end
  
  def display
    if @color == "white"
      "\u265F"
    elsif @color == "black"
      "\u2659"
    end
  end
  
end