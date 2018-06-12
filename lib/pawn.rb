require_relative 'piece.rb'

class Pawn < Piece
  
  def initialize(color)
    @color = color
  end
  
  public
  
  def possible_moves
    moves = []
    white_paths = [[1,1],[0,1],[-1,1]]
    black_paths = [[1,-1],[0,-1],[-1,-1]]
    
    column = self.get_column.ord
    row = self.get_row
    
    #makes a two-square advance possible if a pawn is on its starting square.
    if @color == "white"
      white_paths << [0,2] if row == 2
      possible_paths = white_paths
    elsif @color == "black"
      black_paths << [0,-2] if row == 7
      possible_paths = black_paths
    end
    
    actual_paths = possible_paths.map{|a,b| [a + column, b + row]}.select{|move| in_bounds?(move)}
    
    actual_paths.each{|col, row| moves << "#{col.chr}#{row}"}
    
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