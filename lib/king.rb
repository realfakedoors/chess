require_relative 'piece.rb'

class King < Piece
  
  def initialize(color)
    @color = color
  end
  
  def in_bounds?(move)
    (97..104).include?(move.first) && (1..8).include?(move.last)
  end

  def possible_moves
    moves = []
    
    possible_paths = [[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1],[-1,0]]
    
    column = self.get_column.ord
    row = self.get_row
    
    actual_paths = possible_paths.map{|a,b| [a + column, b + row]}.select{|move| in_bounds?(move)}
    
    actual_paths.each{|col, row| moves << "#{col.chr}#{row}"}

    moves
  end
  
  def display
    if @color == "white"
      "\u265A"
    elsif @color == "black"
      "\u2654"
    end
  end
  
end