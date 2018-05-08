class Piece
  
  def initialize
    @current_square = nil
    @moved = nil
  end
  
  def mark_as_moved
    @moved = true
  end
  
  def check_if_moved?
    @moved
  end
  
  def set_current_square(square)
    @current_square = square
  end
  
  def get_current_square
    @current_square.coords
  end
  
  def get_row
    @current_square.coords.match(/[1-8]/).to_s.to_i
  end
  
  def get_column
    @current_square.coords.match(/[a-h]/).to_s
  end
  
  def get_name
    "#{@type}, #{@color}"
  end
  
  def get_color
    @color
  end
  
  def check(square)
    #not sure if this should go in piece or board...
    row = square.match(/[1-8]/).to_s
    col = square.match(/[a-h]/).to_s
  end
  
  def legal_move?(destination)
    if self.possible_moves.any? {|poss| poss == destination}
      true
    end
  end
  
end