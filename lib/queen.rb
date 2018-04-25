require_relative 'piece.rb'

class Queen < Piece
  
  def initialize(color)
    @color = color
    @type = "Queen"
  end
  
  def display
    if @color == "white"
      "\u265B"
    elsif @color == "black"
      "\u2655"
    end
  end
  
end