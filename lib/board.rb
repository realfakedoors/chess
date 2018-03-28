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
  end
  
  def change_squares(piece, origin, target)
    piece.set_current_square(target)
    set_piece(target, piece)
    set_piece(origin, nil)
    #sets original square to nil after piece is moved.
  end
  
  def move(origin, target)
    
    piece = access(origin).contents
    destination = access(target).contents
    
    if piece == nil      
      puts "there's no piece on that square!"      
    elsif !piece.legal_move?(target)    
      puts "not a legal move!"      
    elsif destination != nil && piece.get_color != destination.get_color 
      @white_graveyard << destination.get_name if destination.get_color == "white"
      @black_graveyard << destination.get_name if destination.get_color == "black"      
      change_squares(piece, origin, target)      
    elsif destination == nil    
      change_squares(piece, origin, target)      
    else      
      puts "theres's a friendly piece on that spot!"      
    end
  end
  
  def new_board
    self.set_piece("a7", Pawn.new("black"))
    self.set_piece("b7", Pawn.new("black"))
    self.set_piece("c7", Pawn.new("black"))
    self.set_piece("d7", Pawn.new("black"))
    self.set_piece("e7", Pawn.new("black"))
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
    system "clear"
    puts ""    
    puts " ------------------------------- "
    
    @board.each do |row|
      puts "x"
    end
      
    puts " ------------------------------- "
    puts "  a   b   c   d   e   f   g   h  "
    puts ""
    
    show_player_names
  end
  
end