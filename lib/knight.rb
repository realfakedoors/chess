require_relative 'piece.rb'

class Knight < Piece
  
  def initialize(color)
    @color = color
  end
  
  public
  
  def possible_moves
    moves = []
    possible_paths = [[1,2],[2,1],[2,-1],[1,-2],[-1,-2],[-2,-1],[-2,1],[-1,2]]
    
    column = self.get_column.ord
    row = self.get_row
    
    actual_paths = possible_paths.map{|a,b| [a + column, b + row]}.select{|move| in_bounds?(move)}
    
    actual_paths.each{|col, row| moves << "#{col.chr}#{row}"}
    
    moves
  end
  
  def display
    if @color == "white"
      "\u265E"
    elsif @color == "black"
      "\u2658"
    end
  end
  
end