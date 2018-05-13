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
  
  ######################################################
  
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
  
  ######################################################
  
end