class Board
  
  def initialize(board = self.empty_board)
    @board = board
    @white_player = "Robin Hood"
    @white_graveyard = ["\u2656","\u2659"]
    @black_player = "Little John"
    @black_graveyard = ["\u265F","\u265F","\u265E"]
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
  
  def new_board
    @board[:a8] = "\u265C"
    @board[:b8] = "\u265E"
    @board[:c8] = "\u265D"
    @board[:d8] = "\u265B"
    @board[:e8] = "\u265A"
    @board[:f8] = "\u265D"
    @board[:g8] = "\u265E"
    @board[:h8] = "\u265C"
    
    @board[:a7] = "\u265F"
    @board[:b7] = "\u265F"
    @board[:c7] = "\u265F"
    @board[:d7] = "\u265F"
    @board[:e7] = "\u265F"
    @board[:f7] = "\u265F"
    @board[:g7] = "\u265F"
    @board[:h7] = "\u265F"
    
    @board[:a2] = "\u2659"
    @board[:b2] = "\u2659"
    @board[:c2] = "\u2659"
    @board[:d2] = "\u2659"
    @board[:e2] = "\u2659"
    @board[:f2] = "\u2659"
    @board[:g2] = "\u2659"
    @board[:h2] = "\u2659"
    
    @board[:a1] = "\u2656"
    @board[:b1] = "\u2658"
    @board[:c1] = "\u2657"
    @board[:d1] = "\u2655"
    @board[:e1] = "\u2654"
    @board[:f1] = "\u2657"
    @board[:g1] = "\u2658"
    @board[:h1] = "\u2656"
  end
  
  def empty_squares
    @board.each do |key, val|
      if val.nil?
        @board[key] = " "
      end
    end
  end
  
  def white_graveyard
    @white_graveyard.each do |captured_piece|
      print "#{captured_piece}"
    end
    puts ""
  end
  
  def black_graveyard
    @black_graveyard.each do |captured_piece|
      print "#{captured_piece}"
    end
    puts ""
  end
  
  def player_names
    puts "White : #{@white_player}"
    black_graveyard
    puts "Black : #{@black_player}"
    white_graveyard
  end
  
  def display
    empty_squares
    system "clear"
    
    puts ""    
    puts " ------------------------------- "
    puts "| #{@board[:a8]} | #{@board[:b8]} | #{@board[:c8]} | #{@board[:d8]} | #{@board[:e8]} | #{@board[:f8]} | #{@board[:g8]} | #{@board[:h8]} | 8"
    puts " ------------------------------- "
    puts "| #{@board[:a7]} | #{@board[:b7]} | #{@board[:c7]} | #{@board[:d7]} | #{@board[:e7]} | #{@board[:f7]} | #{@board[:g7]} | #{@board[:h7]} | 7"
    puts " ------------------------------- "
    puts "| #{@board[:a6]} | #{@board[:b6]} | #{@board[:c6]} | #{@board[:d6]} | #{@board[:e6]} | #{@board[:f6]} | #{@board[:g6]} | #{@board[:h6]} | 6"
    puts " ------------------------------- "
    puts "| #{@board[:a5]} | #{@board[:b5]} | #{@board[:c5]} | #{@board[:d5]} | #{@board[:e5]} | #{@board[:f5]} | #{@board[:g5]} | #{@board[:h5]} | 5"
    puts " ------------------------------- "
    puts "| #{@board[:a4]} | #{@board[:b4]} | #{@board[:c4]} | #{@board[:d4]} | #{@board[:e4]} | #{@board[:f4]} | #{@board[:g4]} | #{@board[:h4]} | 4"
    puts " ------------------------------- "
    puts "| #{@board[:a3]} | #{@board[:b3]} | #{@board[:c3]} | #{@board[:d3]} | #{@board[:e3]} | #{@board[:f3]} | #{@board[:g3]} | #{@board[:h3]} | 3"
    puts " ------------------------------- "
    puts "| #{@board[:a2]} | #{@board[:b2]} | #{@board[:c2]} | #{@board[:d2]} | #{@board[:e2]} | #{@board[:f2]} | #{@board[:g2]} | #{@board[:h2]} | 2"
    puts " ------------------------------- "
    puts "| #{@board[:a1]} | #{@board[:b1]} | #{@board[:c1]} | #{@board[:d1]} | #{@board[:e1]} | #{@board[:f1]} | #{@board[:g1]} | #{@board[:h1]} | 1"
    puts " ------------------------------- "
    puts "  a   b   c   d   e   f   g   h  "
    puts ""
    
    player_names
  end
  
end

board = Board.new
board.new_board
board.display