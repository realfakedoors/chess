class Game
  
  def play
    board = Board.new
    board.new_board
    board.move("a2", "a4")
    board.move("c7", "c6")
    board.display
  end
  
end