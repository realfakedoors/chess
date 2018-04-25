class Board
  
  def initialize(board = self.empty_board)
    @board = board
    @white_player = "Robin Hood"
    @white_graveyard = []
    @black_player = "Little John"
    @black_graveyard = []
  end
  
  def empty_board
    board = []

    8.downto(1).each do |row_number|
      board_row = []
      "a".upto("h").each do |col_letter|
        board_row << Square.new(col_letter, row_number.to_s)
      end
      board << board_row
    end
    board
  end
  
  def access(square)
    #takes a string with a letter and number as input,
    #and returns the corresponding square.
    column = square.match(/[a-h]/).to_s
    row = square.match(/[1-8]/).to_s.to_i
    row -= 9
    row = row.abs.to_s
    @board[row.to_i - 1][column.ord - 97]
  end
  
  def set_piece(square, piece = nil)
    square = access(square)
    square.set_contents(piece)
    if !piece.nil?
      piece.set_current_square(square)
    end
  end
  
  def change_squares(piece, origin, target)
    piece.set_current_square(target)
    set_piece(target, piece)
    set_piece(origin, nil)
    #sets original square to nil after piece is moved.
  end
  
  def column_adjacent?(piece, target)
    if target == nil
      false
    elsif piece.get_column.ord == target.get_column.ord - 1 || piece.get_column.ord == target.get_column.ord + 1
      return true
    else
      false
    end
  end
  
  def pawn_attack_moves(piece, destination)
    #plugs into 'move' to ensure a pawn can only attack diagonally.
    if destination == nil
      false
    elsif piece.get_color == "black" && destination.get_color == "white" 
      return true if destination.get_row == (piece.get_row - 1) && column_adjacent?(piece, destination)
    elsif piece.get_color == "white" && destination.get_color == "black" 
      return true if destination.get_row == (piece.get_row + 1) && column_adjacent?(piece, destination)
    else
      false
    end
  end
  
  def pawn_blocked?(piece, target)
    if piece.get_color == "black"
      square_in_front = access("#{piece.get_column}#{piece.get_row - 1}")
      return true if square_in_front.contents != nil
    elsif piece.get_color == "white"
      square_in_front = access("#{piece.get_column}#{piece.get_row + 1}")
      return true if square_in_front.contents != nil
    else
      return false
    end
  end
  
  def eligible_for_promotion?(pawn)
    if pawn.get_row == 7 && pawn.get_color == "white"
      true
    elsif pawn.get_row == 2 && pawn.get_color == "black"
      true
    else false
    end
  end
  
  def promote(piece, origin, target)
    friendly_color = piece.get_color
    set_piece(origin)
    set_piece(target, Queen.new(friendly_color))
  end
  
  def pawn_movement(piece, destination, origin, target)
    if !column_adjacent?(piece, destination) && pawn_blocked?(piece, destination)
      puts "another piece is in the way!"
      return
    elsif !pawn_attack_moves(piece, destination) && column_adjacent?(piece, destination)
      puts "pawns can only attack diagonally!"
      return
    elsif eligible_for_promotion?(piece)
      promote(piece, origin, target)
    else
      capture(piece, destination, origin, target)
    end
  end
  
  def capture(piece, destination, origin, target)
    change_squares(piece, origin, target)
    return if destination.nil?
    @white_graveyard << destination.display if destination.get_color == "white"
    @black_graveyard << destination.display if destination.get_color == "black"      
  end
  
  def move(origin, target)
    
    piece = access(origin).contents
    destination = access(target).contents
    
    if piece == nil      
      puts "there's no piece on that square!"      
    elsif !piece.legal_move?(target)    
      puts "not a legal move!"
    elsif piece.class == Pawn
      pawn_movement(piece, destination, origin, target)
    elsif destination != nil && piece.get_color != destination.get_color 
      capture(piece, destination, origin, target)    
    elsif destination == nil    
      change_squares(piece, origin, target)      
    else      
      puts "theres's a friendly piece on that spot!"      
    end
  end
  
  def new_board
    
    #sets all pawns of both colors - SAVE
  #  "a".upto("h").each do |col|
  #    self.set_piece("#{col}7", Pawn.new("black"))
  #    self.set_piece("#{col}2", Pawn.new("white"))
  #  end
    
    self.set_piece("c2", Pawn.new("black"))
    self.set_piece("d1", Pawn.new("white"))
  end
  
  def print_white_graveyard
    @white_graveyard.each do |captured_piece|
      print "#{captured_piece}"
    end
    puts ""
  end
  
  def print_black_graveyard
    @black_graveyard.each do |captured_piece|
      print "#{captured_piece}"
    end
    puts ""
  end
  
  def show_player_names
    puts "White : #{@white_player}"
    print_black_graveyard
    puts "Black : #{@black_player}"
    print_white_graveyard
  end
  
  def display
  #  system "clear"
    puts ""    
    puts "    -------------------------------    "
    @board.each_with_index do |row, i|
      i = (i - 8).abs
      print " #{i} "
      row.each {|square| print "| #{square.contents.display || " "} "}
      puts "|"
      puts "    -------------------------------    "
    end
    puts "     a   b   c   d   e   f   g   h     "
    puts ""    
    show_player_names
  end
  
end