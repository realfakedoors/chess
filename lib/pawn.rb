require_relative 'piece.rb'

class Pawn < Piece
  
  def initialize(color)
    @color = color
    @type = "Pawn"
  end
  
  def possible_moves
    moves = []
    white_paths = [[1,1],[0,1],[-1,1]]
    black_paths = [[1,-1],[0,-1],[-1,-1]]
    
    column = self.get_column.ord
    row = self.get_row
    
    if @color == "white"
      white_paths << [0,2] if row == 2
      possible_paths = white_paths
    elsif @color == "black"
      black_paths << [0,-2] if row == 7
      possible_paths = black_paths
    end
    
    actual_paths = possible_paths.map{|a,b| [a + column, b + row]}.select{|move| in_bounds?(move)}
    
    actual_paths.each{|col, row| moves << "#{col.chr}#{row}"}
    
#    if @color == "white"
#      (column.ord..column.ord + 2).each do |col|
#        col -= 1
#        moves << "#{col.chr}#{(row + 1)}"
#      end
#      if row == 2
#        moves << "#{column}#{(row + 2)}"
#      end
#    elsif @color == "black"
#      (column.ord..column.ord + 2).each do |col|
#        col -= 1
#        moves << "#{col.chr}#{(row - 1)}"
#      end
#      if row == 7
#        moves << "#{column}#{(row - 2)}"
#      end
#    end
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