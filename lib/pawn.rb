require_relative 'piece.rb'

class Pawn < Piece
  
  def initialize(color)
    @color = color
    @type = "Pawn"
  end
  
  def possible_moves
    []
  end
  
  def display
    if @color == "white"
      "\u265F"
    elsif @color == "black"
      "\u2659"
    else
      "x"
    end
  end
  
end