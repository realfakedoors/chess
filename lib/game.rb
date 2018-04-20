class Game
  
  def play
    board = Board.new
    board.new_board
    board.move("b2", "b3")
    board.display
  end
  
  ########################
  
  def welcome_screen
    puts "Welcome to Chess!"
    puts "enter 'N' for a new game, or 'L' to load a previous saved game."
    
    choice = gets.chomp.upcase
    if choice == "N"
      new_game
    elsif choice == "L"
      load_screen
    else
      puts "whoops! enter either 'N' or 'L.'"
    end
  end
  
  def new_game
    #to do: enter player names
    board = Board.new
    board.new_board
    board.display
  end
  
  def load_screen
    #to do: display saves from saves folder,
    #implement to_yaml and from_yaml functions
  end
  
end