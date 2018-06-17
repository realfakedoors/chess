class Board
  
  attr_accessor :current_player, :board, :error_message, :en_passant
  
  def initialize(white, black, board = self.empty_board, current_player = "white")
    @board = board
    
    #graveyards represent the pieces each player has captured.
    @white_player = [white, "white"]
    @white_graveyard = []
    
    @black_player = [black, "black"]
    @black_graveyard = []
    
    #skipping this default value is important for loading a saved game where it happens to be black's turn.
    if current_player == "white"
      @current_player = @white_player
    else
      @current_player = @black_player
    end
    
    #a flag for checking en passant status each turn: only not nil if a pawn made a two-square advance last turn.
    @en_passant = nil

    #these display if an error is made, or if check or checkmate.
    @error_message = ""
    @check_message = ""
  end
  
  public
  
  def checkmate?
    true if king_in_check? && !legal_moves_possible?
  end
  
  def stalemate?
    true if !king_in_check? && !legal_moves_possible?
  end
  
  def empty_board
    #creates 64 squares, places them on the board, and letters/numbers them accordingly.
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
  
  def set_piece(square, piece = nil)
    square = access(square)
    square.set_contents(piece)
    if !piece.nil?
      piece.set_current_square(square)
    end
  end
  
  def change_squares(piece, origin, target)
    piece.set_current_square(target)
    if piece.is_a?(King) || piece.is_a?(Rook)
      piece.mark_as_moved
    end
    set_piece(target, piece)
    #sets original square to nil after piece is moved.
    set_piece(origin, nil)
  end
  
  def new_board
    "a".upto("h").each do |col|
      set_piece("#{col}7", Pawn.new("black"))
      set_piece("#{col}2", Pawn.new("white"))
    end

    set_piece("a1", Rook.new("white"))
    set_piece("h1", Rook.new("white"))
    set_piece("a8", Rook.new("black"))
    set_piece("h8", Rook.new("black"))
    
    set_piece("b1", Knight.new("white"))
    set_piece("g1", Knight.new("white"))
    set_piece("b8", Knight.new("black"))
    set_piece("g8", Knight.new("black"))
    
    set_piece("c1", Bishop.new("white"))
    set_piece("f1", Bishop.new("white"))
    set_piece("c8", Bishop.new("black"))
    set_piece("f8", Bishop.new("black"))
    
    set_piece("d1", Queen.new("white"))
    set_piece("d8", Queen.new("black"))
    
    set_piece("e1", King.new("white"))
    set_piece("e8", King.new("black"))
  end
  
  def get_player_names
    [@white_player[0], @black_player[0]]
  end
  
  def display
    system "clear"
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
    show_error_messages
    puts "It's #{current_player[0]}'s turn!"
    puts "Enter your next move, or 'menu' for options!"
    puts ""
  end
  
  def switch_players
    @current_player == @white_player ? @current_player = @black_player : @current_player = @white_player
    #resets the error message, since we only switch players if a turn is legal.
    @error_message = nil
  end
  
  def king_in_check?
    friendly_pieces = []
    hostile_pieces = []
    
    @board.flatten.select{|sq| !sq.contents.nil?}.each do |sq| 
      sq.contents.color == @current_player[1] ? friendly_pieces << sq.contents : hostile_pieces << sq.contents
    end
    
    friendly_king = friendly_pieces.select{|pc| pc.is_a?(King)}.first
    
    hostiles_threatening_king = hostile_pieces.select do |pc|
      pc.possible_moves.any? do |move|
        if pc.is_a?(Pawn)
          pawn_attack_moves?(pc, friendly_king, pc.get_current_square, friendly_king.get_current_square)
        else
          move == friendly_king.get_current_square && not_blocked?(pc, pc.get_current_square, friendly_king.get_current_square)
        end
      end
    end
    if hostiles_threatening_king.any?{|pc| !pc.nil?}
      @check_message = "Check!"
      return true 
    else 
      return false
    end
  end
  
  def move(origin, target)
    
    piece = access(origin).contents
    destination = access(target).contents
    
    if piece == nil      
      @error_message = "there's no piece on that square!"
    elsif piece.color != @current_player[1]
      @error_message = "wrong color! it's not your turn!"
    elsif !piece.legal_move?(target)    
      @error_message = "not a legal move!"
    elsif !destination.nil? && piece.color == destination.color
      @error_message = "no friendly fire!"
    elsif piece.is_a?(Pawn)
      pawn_movement(piece, destination, origin, target)
    elsif not_blocked?(piece, origin, target)
      record_board_state
      non_pawn_movement(piece, destination, origin, target)
      king_threatened?
    else
      @error_message = "you're blocked by another piece!"
    end
  end
  
  def castle(color, direction)
    if castle_eligible?(color, direction)
      if king_in_check?
        @error_message = "you can't castle out of check!"
        return
      else
        record_board_state
        castle_move(color, direction)
        king_threatened?
      end
    else
      @error_message = "you can't castle that way!"
      return
    end
  end
  
  def access(square)
    #takes a string with a letter and number as input, and returns the corresponding square.
    column = square.match(/[a-h]/).to_s
    row = square.match(/[1-8]/).to_s.to_i
    row -= 9
    row = row.abs.to_s
    @board[row.to_i - 1][column.ord - 97]
  end
  
  private
  
  def legal_moves_possible?
    true unless find_legal_moves.first.nil?
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
    puts "White : #{@white_player[0]}"
    print_black_graveyard
    puts "Black : #{@black_player[0]}"
    print_white_graveyard
  end
  
  def show_error_messages
    puts @error_message
    puts @check_message
  end
  
  def castle_eligible?(color, direction)
    color == "white" ? row = 1 : row = 8    
    direction == "left" ? rook_column = "a" : rook_column = "h"
    
    rook = access("#{rook_column}#{row}").contents
    if rook != nil
      check_rook = rook.moved
    end
    
    king = access("e#{row}").contents
    if king != nil
      check_king = king.moved
    end
    
    if check_rook == nil && check_king == nil
      check_horizontals(row, "e".ord, rook_column.ord)
    else 
      false
    end
  end
  
  def castle_move(color, direction)
    color == "white" ? row = 1 : row = 8
    set_piece("e#{row}", nil)
    
    if direction == "left"
      set_piece("a#{row}", nil)
      set_piece("c#{row}", King.new(color))
      set_piece("d#{row}", Rook.new(color))
    else
      set_piece("h#{row}", nil)
      set_piece("g#{row}", King.new(color))
      set_piece("f#{row}", Rook.new(color))
    end
  end
  
  def capture(piece, destination, origin, target)
    change_squares(piece, origin, target)
    return if destination.nil?
    @white_graveyard << destination.display if destination.color == "white"
    @black_graveyard << destination.display if destination.color == "black"      
  end
  
  def check_each(array_of_squares)
    if array_of_squares.any? {|square| !access(square).contents.nil?}
      return false
    else true
    end
  end
  
  def check_diagonals(starting_row, ending_row, starting_column, ending_column)
    squares = []
    #next in each loop, so we're only grabbing the squares in between.
    #up-right
    if starting_row < ending_row && starting_column < ending_column
      (starting_row...ending_row).each do |row|
        next if row == starting_row
        starting_column += 1
        squares << "#{starting_column.chr}#{row}"
      end
    #up-left
    elsif starting_row < ending_row && starting_column > ending_column
      (starting_row...ending_row).each do |row|
        next if row == starting_row
        starting_column -= 1
        squares << "#{starting_column.chr}#{row}"
      end
    #down-left
    elsif starting_row > ending_row && starting_column > ending_column
        starting_row.downto(ending_row).each do |row|
        next if row == starting_row || row == ending_row
        starting_column -= 1
        squares << "#{starting_column.chr}#{row}"
      end
    #down-right
    else
      starting_row.downto(ending_row).each do |row|
        next if row == starting_row || row == ending_row
        starting_column += 1
        squares << "#{starting_column.chr}#{row}"
      end
    end
    check_each(squares)
  end
  
  def check_horizontals(starting_row, starting_column, ending_column)
    squares = []
    #left
    if starting_column > ending_column
      starting_column.downto(ending_column).each do |col|
        next if col == starting_column || col == ending_column
        squares << "#{col.chr}#{starting_row}"
      end
    #right
    else
      (starting_column...ending_column).each do |col|
        next if col == starting_column
        squares << "#{col.chr}#{starting_row}"
      end
    end
    check_each(squares)
  end
  
  def check_verticals(starting_row, ending_row, starting_column)
    squares = []
    #up
    if starting_row < ending_row
      (starting_row...ending_row).each do |row|
        next if row == starting_row
        squares << "#{starting_column.chr}#{row}"
      end
    #down
    else
      starting_row.downto(ending_row).each do |row|
        next if row == starting_row || row == ending_row
        squares << "#{starting_column.chr}#{row}"
      end
    end
    check_each(squares)
  end
  
  def not_blocked?(piece, origin, target)
    return true if piece.is_a?(Knight)
    
    starting_square = access(origin)
    ending_square = access(target)
    
    starting_row = starting_square.row.to_i
    starting_column = starting_square.column.ord
    ending_row = ending_square.row.to_i
    ending_column = ending_square.column.ord
    
    if starting_row != ending_row && starting_column != ending_column
      check_diagonals(starting_row, ending_row, starting_column, ending_column)
    elsif starting_row == ending_row
      check_horizontals(starting_row, starting_column, ending_column)
    else
      check_verticals(starting_row, ending_row, starting_column)
    end
  end
  
  def non_pawn_movement(piece, destination, origin, target)
    if destination != nil && piece.color != destination.color
      capture(piece, destination, origin, target)
    elsif destination == nil
      change_squares(piece, origin, target)
    else      
      @error_message = "there's a friendly piece on that spot!"      
    end
  end
  
  def record_board_state
    #saves the board before a move is made, in case it's illegal and needs to be reverted.
    @prev_board_state = {}
    @board.flatten.each do |square|
      next if square.contents == nil
      column = square.column
      row = square.row
      contents = square.contents
      
      @prev_board_state["#{column}#{row}"] = contents
    end
  end
  
  def revert_illegal_move
    #brings the board back to its previous state when an illegal move is made.
    @board = []
    @board = self.empty_board
    
    @prev_board_state.each do |coords, contents|
      set_piece(coords, contents)
    end
    
    @error_message = "You can't put your own king in danger!"
  end
  
  def king_threatened?
    if king_in_check?
      revert_illegal_move
    else
      switch_players
    end
  end
  
  def set_from_previous(board)
    @prev_board_state.each do |coords, contents|
      board.set_piece(coords, contents)
    end
  end
  
  def find_legal_moves
    #look for legal moves by creating a dummy board, making every move
    #possible, and record the move if it doesn't put the king in check.
    record_board_state
    fresh_board = Board.new("w","b")
    fresh_board.empty_board
    legal_moves = []
    
    set_from_previous(fresh_board)
    #find all friendly pieces on the board.
    friendly_pieces = []
    fresh_board.board.flatten.each do |square|
      next if square.contents == nil || square.contents.color != @current_player[1]
      friendly_pieces << square.contents
    end
    #run through every friendly piece's possible moves.
    friendly_pieces.each do |piece|
      potential_moves = []
      this_square = piece.get_current_square
      piece.possible_moves.each do |move|
        if !access(move).contents.nil?
          destination = access(move).contents
        else
          destination = nil
        end
        #record every move that isn't blocked, including captures.
        if piece.is_a?(Pawn)
          if !column_adjacent?(this_square, move) && !pawn_blocked?(piece, destination)
            potential_moves << move
          elsif column_adjacent?(this_square, move) && pawn_attack_moves?(piece, destination, this_square, move)
            potential_moves << move
          else next
          end
        elsif not_blocked?(piece, this_square, move) 
          if destination.nil?
            potential_moves << move
          elsif piece.color != destination.color
            potential_moves << move
          end
        end
      end
      #finally, return every move that doesn't endanger the friendly king.
      potential_moves.each do |potential_move|
        fresh_board.empty_board
        set_from_previous(fresh_board)      
        fresh_board.change_squares(piece, this_square, potential_move)
        if !fresh_board.king_in_check?
          legal_moves << potential_move
        else
          fresh_board.change_squares(piece, potential_move, this_square)
        end
      end
    end
    set_from_previous(fresh_board)
    legal_moves
  end
  
  #################### pawn-specific methods ####################
    
  def column_adjacent?(origin, target)
    origin_square = access(origin)
    target_square = access(target)
    
    if origin_square.column.ord == target_square.column.ord - 1 || origin_square.column.ord == target_square.column.ord + 1
      return true
    else
      false
    end
  end
  
  def move_en_passant(piece, target) 
    if piece.color == "white"
      enemy_square = access("#{target.column}#{target.row.to_i - 1}")
      @white_graveyard << enemy_square.contents.display
    elsif piece.color == "black"
      enemy_square = access("#{target.column}#{target.row.to_i + 1}")
      @black_graveyard << enemy_square.contents.display
    end
    enemy_square.set_contents(nil)
  end
    
  
  def pawn_attack_moves?(piece, destination, origin, target)
    #plugs into 'pawn_movement' to ensure a pawn can only attack diagonally.
    target = access(target)
    if @en_passant != nil
      if @en_passant[0] == target.coords && @en_passant[1] != piece.color
        move_en_passant(piece, target)
        true
      end
    elsif destination == nil
      false    
    elsif piece.color == "black" && destination.color == "white" 
      return true if destination.get_row == (piece.get_row - 1) && column_adjacent?(origin, target.coords)
    elsif piece.color == "white" && destination.color == "black" 
      return true if destination.get_row == (piece.get_row + 1) && column_adjacent?(origin, target.coords)
    else
      false
    end
  end
  
  def pawn_blocked?(piece, target)
    if piece.color == "black"
      square_in_front = access("#{piece.get_column}#{piece.get_row - 1}")
      return true if square_in_front.contents != nil
    elsif piece.color == "white"
      square_in_front = access("#{piece.get_column}#{piece.get_row + 1}")
      return true if square_in_front.contents != nil
    else
      return false
    end
  end
  
  def eligible_for_promotion?(pawn)
    if pawn.get_row == 7 && pawn.color == "white"
      true
    elsif pawn.get_row == 2 && pawn.color == "black"
      true
    else false
    end
  end
  
  def promote(piece, origin, target)
    friendly_color = piece.color
    set_piece(origin)
    set_piece(target, Queen.new(friendly_color))
  end
  
  def en_passant_eligible?(piece, target)
    target_row = target.match(/\d/).to_s.to_i
    
    if piece.color == "white" && piece.get_row == 2
      return true if target_row == 4
    elsif piece.color == "black" && piece.get_row == 7
      return true if target_row == 5
    end
    false
  end
  
  def set_en_passant(piece, target)
    set_column = piece.get_column
    set_row = (piece.get_row + target.match(/\d/).to_s.to_i) / 2
    set_color = piece.color
    @en_passant = ["#{set_column}#{set_row}", "#{set_color}"]
  end
  
  def pawn_movement(piece, destination, origin, target)
    if column_adjacent?(origin, target)
      if pawn_attack_moves?(piece, destination, origin, target)
        record_board_state
        capture(piece, destination, origin, target)
        king_threatened?
      else
        @error_message = "pawns can only attack diagonally!"
      end
    elsif pawn_blocked?(piece, destination)
      @error_message = "another piece is in the way!"
    elsif eligible_for_promotion?(piece)
      record_board_state
      promote(piece, origin, target)
      king_threatened?
    else
      record_board_state
      set_en_passant(piece, target) if en_passant_eligible?(piece, target)
      capture(piece, destination, origin, target)
      king_threatened?
    end
  end
  
end