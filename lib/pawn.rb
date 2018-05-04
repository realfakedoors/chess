require_relative 'piece.rb'

class Pawn < Piece
  
  def initialize(color)
    @color = color
    @type = "Pawn"
  end
  
  def possible_moves
    moves = []
    
    column = self.get_column
    row = self.get_row
    
    if @color == "white"
      (column.ord..column.ord + 2).each do |col|
        col -= 1
        moves << "#{col.chr}#{(row + 1)}"
      end
      if row == 2
        moves << "#{column}#{(row + 2)}"
      end
    elsif @color == "black"
      (column.ord..column.ord + 2).each do |col|
        col -= 1
        moves << "#{col.chr}#{(row - 1)}"
      end
      if row == 7
        moves << "#{column}#{(row - 2)}"
      end
    end
    moves
  end
  
  def display
    if @color == "white"
      "\u265F"
    elsif @color == "black"
      "\u2659"
    end
  end
  
end