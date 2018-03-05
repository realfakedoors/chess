class Game
  
  def play
    board = Board.new
    board.empty_board
    board.set_piece(:a3, Pawn.new("white"))
    board.set_piece(:a4, Pawn.new("black"))
    board.set_piece(:b3, Pawn.new("black"))
    board.set_piece(:b4, Pawn.new("white"))
    board.move(:a3, :a4)
    board.move(:b3, :b4)
    board.print_white_graveyard
    board.print_black_graveyard
  end
  
end