class Piece
  
  attr_accessor :moved, :color, :current_square
  
  def initialize
    @current_square = nil
    @moved = nil
  end
  
  public
  
  #important for checking if a castle move is possible for Kings/Rooks.
  def mark_as_moved
    @moved = true
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
  
  def legal_move?(destination)
    if possible_moves.any? {|poss| poss == destination}
      true
    end
  end
  
  private
  
  def in_bounds?(move)
    (97..104).include?(move.first) && (1..8).include?(move.last)
  end
  
  def get_right_diags(column, row)
    opposite_row = row
    right_diags = []

    column.upto("h") do |col|
      next if col == column
      row += 1
      opposite_row -= 1
      unless row > 8
        right_diags << "#{col}#{row}"
      end
      unless opposite_row < 1
        right_diags << "#{col}#{opposite_row}"
      end
    end
    right_diags
  end

  def get_left_diags(column, row)
    opposite_row = row
    left_diags = []

    (column.ord).downto("a".ord) do |col|
      col = col.chr
      next if col == column
      row -= 1
      opposite_row += 1
      unless row < 1
        left_diags << "#{col}#{row}"
      end
      unless opposite_row > 8
        left_diags << "#{col}#{opposite_row}"
      end
    end
    left_diags
  end

  def get_verticals(column, row)
    verticals = []

    1.upto(8) do |row_number|
      next if row_number == row
      verticals << "#{column}#{row_number}"
    end

    verticals
  end

  def get_horizontals(column, row)
    horizontals = []

    "a".ord.upto("h".ord) do |col_letter|
      next if col_letter == column.ord
      horizontals << "#{col_letter.chr}#{row}"
    end

    horizontals
  end
  
end