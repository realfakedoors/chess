require_relative 'piece.rb'

class Knight < Piece
  
  def initialize(color)
    @color = color
    @type = "Knight"
  end
  
  def possible_moves

  end
  
  def display
    if @color == "white"
      "\u265E"
    elsif @color == "black"
      "\u2658"
    end
  end
  
end