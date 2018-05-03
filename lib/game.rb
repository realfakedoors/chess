class Game
  
  def play
    @board = Board.new
    @board.new_board
    
    until checkmate?
      @board.display
      interact_with_board
    end
    game_over_screen
  end
  
  def checkmate?
    return true if @board.checkmate?
  end
  
  def interact_with_board
    puts "it's #{current_player}'s turn!"
    puts "enter your next move, or 'menu' for options!"
    input = gets.chomp
    
    if input == "menu"
      options_menu
    elsif input.match(/[a-h][1-8],\s[a-h][1-8]/)
      origin_square = input.match(/^([a-h][1-8])/).to_s
      target_square = input.match(/([a-h][1-8])$/).to_s
      @board.move(origin_square, target_square)
      #@board.switch_players
      #to do: create method that switches @current_player
    else
      puts "invalid input, try again!"
    end
  end
    
  def options_menu
    "options:"
  end
  
  def current_player
    @board.current_player
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
    @board = Board.new
    @board.new_board
    @board.display
  end
  
  def load_screen
    #to do: display saves from saves folder,
    #implement to_yaml and from_yaml functions
  end
  
  def game_over_screen
    puts "game over! #{current_player} wins!"
  end
  
end