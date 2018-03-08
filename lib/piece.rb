class Piece
  
  def initialize
    @current_square = nil
  end
  
  def set_current_square(square)
    @current_square = square
  end
  
  def get_current_square
    @current_square
  end
  
  def get_name
    "#{@type}, #{@color}"
  end
  
  def get_color
    @color
  end
  
  def legal_move?(destination)
    if self.possible_moves.any? {|poss| poss == destination}
      true
    end
  end
  
end