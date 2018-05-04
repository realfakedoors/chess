require_relative 'piece.rb'

class Rook < Piece
  
  def initialize(color)
    @color = color
    @type = "Rook"
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

  def possible_moves
    moves = []

    column = self.get_column
    row = self.get_row

    moves << get_verticals(column, row)
    moves << get_horizontals(column, row)
    moves.flatten!
  end
  
  def display
    if @color == "white"
      "\u265C"
    elsif @color == "black"
      "\u2656"
    end
  end
  
end