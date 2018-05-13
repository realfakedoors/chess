class Game
  
  def play    
#    welcome_screen
    @board = Board.new("Robin Hood", "Little John")
    @board.new_board
    until checkmate?
      interact_with_board
    end
    game_over_screen
  end
  
  def welcome_screen
    system "clear"
    puts "Chess"
    puts "A game by Andy Holt"
    puts "enter a name for player white:"
    white_player = gets.chomp
    puts "enter a name for player black:"
    black_player = gets.chomp
    @board = Board.new(white_player, black_player)
    @board.new_board
  end
  
  def checkmate?
    return true if @board.checkmate?
  end
  
  def interact_with_board
    @board.king_in_check?
    @board.display
    
    input = gets.chomp
    
    if input == "menu"
      options_menu
    elsif input.match(/^(castle)/)
      if input.match(/(left)$/)
        direction = "left"
      elsif input.match(/(right)$/)
        direction = "right"
      else return
      end
      @board.castle(current_player[1], direction)
    elsif input.match(/[a-h][1-8],\s[a-h][1-8]/)
      origin_square = input.match(/^([a-h][1-8])/).to_s
      target_square = input.match(/([a-h][1-8])$/).to_s
      @board.move(origin_square, target_square)
    else
      puts "invalid input, try again!"
    end
  end
    
  def options_menu
    system "clear"
    puts "Options:"
    puts "For general instructions on how to play, type 'tutorial'."
    puts "To save the game, type 'save'."
    puts "To start a previously saved game, type 'load'."
    puts "To resume your game, type 'x'."
    
    input = gets.chomp
    return if input.downcase == "x"
    if input.downcase == "tutorial"
      tutorial
      return
    end
  end
  
  def tutorial
    system "clear"
    puts "How to play:"
    puts ""
    puts "Move your pieces by entering your piece's square,"
    puts "followed by a comma, then your destination square."
    puts "for example: 'a2, a4'."
    puts ""
    puts "To castle, enter 'castle left' or 'castle right'."
    puts ""
    puts "To resume your game, press 'x'."
    input = gets.chomp
    return if input.downcase == "x"
  end
  
  def current_player
    @board.current_player
  end
    
  
  ########################
  
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