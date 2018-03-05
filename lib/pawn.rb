require_relative 'piece.rb'

class Pawn < Piece
  
  def initialize(color)
    @color = color
    @type = "Pawn"
  end
  
  def possible_moves
    [:a3, :a4, :a5, :b3, :b4]
  end
  
end