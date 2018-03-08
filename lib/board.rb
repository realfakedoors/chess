class Board
  
  def initialize(board = self.empty_board)
    @board = board
    @white_player = "Robin Hood"
    @white_graveyard = []
    @black_player = "Little John"
    @black_graveyard = []
  end
  
  def empty_board
    board_hash = {}
    8.downto(1).each do |row|
      ("a".."h").each do |col|
        board_hash["#{col}#{row}".to_sym] = nil
      end
    end
    board_hash
  end
  
  def access(square)
    @board[square]
  end
  
  def set_piece(square, piece = nil)
    @board[square] = piece
    piece.set_current_square(square)
  end
  
  def change_squares(piece, origin, target)
    piece.set_current_square(target)
    set_piece(target, piece)
    set_piece(origin, EmptySquare.new)
    #sets original square to nil after piece is moved.
  end
  
  def move(origin, target)
    
    piece = access(origin)
    destination = access(target)
    
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
    self.set_piece(:a7, Pawn.new("black"))
    self.set_piece(:b7, Pawn.new("black"))
    self.set_piece(:c7, Pawn.new("black"))
    self.set_piece(:d7, Pawn.new("black"))
    self.set_piece(:e7, Pawn.new("black"))
    self.set_piece(:f7, Pawn.new("black"))
    self.set_piece(:g7, Pawn.new("black"))
    self.set_piece(:h7, Pawn.new("black"))
    
    self.set_piece(:a2, Pawn.new("white"))
    self.set_piece(:b2, Pawn.new("white"))
    self.set_piece(:c2, Pawn.new("white"))
    self.set_piece(:d2, Pawn.new("white"))
    self.set_piece(:e2, Pawn.new("white"))
    self.set_piece(:f2, Pawn.new("white"))
    self.set_piece(:g2, Pawn.new("white"))
    self.set_piece(:h2, Pawn.new("white"))
  end
  
  def empty_squares
    @board.each do |key, val|
      if val.nil?
        @board[key] = EmptySquare.new
      end
    end
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
    empty_squares
    system "clear"
    
    puts ""    
    puts " ------------------------------- "
    puts "| #{@board[:a8].display} | #{@board[:b8].display} | #{@board[:c8].display} | #{@board[:d8].display} | #{@board[:e8].display} | #{@board[:f8].display} | #{@board[:g8].display} | #{@board[:h8].display} | 8"
    puts " ------------------------------- "
    puts "| #{@board[:a7].display} | #{@board[:b7].display} | #{@board[:c7].display} | #{@board[:d7].display} | #{@board[:e7].display} | #{@board[:f7].display} | #{@board[:g7].display} | #{@board[:h7].display} | 7"
    puts " ------------------------------- "
    puts "| #{@board[:a6].display} | #{@board[:b6].display} | #{@board[:c6].display} | #{@board[:d6].display} | #{@board[:e6].display} | #{@board[:f6].display} | #{@board[:g6].display} | #{@board[:h6].display} | 6"
    puts " ------------------------------- "
    puts "| #{@board[:a5].display} | #{@board[:b5].display} | #{@board[:c5].display} | #{@board[:d5].display} | #{@board[:e5].display} | #{@board[:f5].display} | #{@board[:g5].display} | #{@board[:h5].display} | 5"
    puts " ------------------------------- "
    puts "| #{@board[:a4].display} | #{@board[:b4].display} | #{@board[:c4].display} | #{@board[:d4].display} | #{@board[:e4].display} | #{@board[:f4].display} | #{@board[:g4].display} | #{@board[:h4].display} | 4"
    puts " ------------------------------- "
    puts "| #{@board[:a3].display} | #{@board[:b3].display} | #{@board[:c3].display} | #{@board[:d3].display} | #{@board[:e3].display} | #{@board[:f3].display} | #{@board[:g3].display} | #{@board[:h3].display} | 3"
    puts " ------------------------------- "
    puts "| #{@board[:a2].display} | #{@board[:b2].display} | #{@board[:c2].display} | #{@board[:d2].display} | #{@board[:e2].display} | #{@board[:f2].display} | #{@board[:g2].display} | #{@board[:h2].display} | 2"
    puts " ------------------------------- "
    puts "| #{@board[:a1].display} | #{@board[:b1].display} | #{@board[:c1].display} | #{@board[:d1].display} | #{@board[:e1].display} | #{@board[:f1].display} | #{@board[:g1].display} | #{@board[:h1].display} | 1"
    puts " ------------------------------- "
    puts "  a   b   c   d   e   f   g   h  "
    puts ""
    
    show_player_names
  end
  
end

class EmptySquare
  
  def display
    " "
  end
  
  def set_current_square(square)
    @current_square = square
  end
  
end