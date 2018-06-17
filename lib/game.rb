class Game
  
  require 'yaml'
  require 'date'
  require 'io/console'
  
  public
  
  def play
    welcome_screen
    until game_over?
      interact_with_board
    end
    game_over_screen
  end
  
  private
  
  def game_over?
    return true if @board.stalemate? || @board.checkmate?
  end
  
  def current_player
    @board.current_player
  end
  
  def interact_with_board
    #checks if friendly king is in check before receiving player input.
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
  
  def save_game
    board_state = @board.board
    player_names = @board.get_player_names
    #already a method in game.rb for current_player.
    datetime = DateTime.now
    
    data = [board_state, player_names, current_player[1]]
    
    File.open("save/#{player_names[0]} vs #{player_names[1]} - #{datetime}", "w"){|q| q.write(YAML.dump(data))}
  end
  
  def saved_games
    saves = []
    
    Dir.entries("save").each do |file|
      next if file == "." || file == ".."
      saves << file
    end
    
    saves
  end
  
  def display_saves
    saved_games.each_with_index do |file, i|
      puts "Save ##{i + 1}: #{file}"
    end
  end
  
  def load_game
    system "clear"
    puts "Saved Games:"
    puts ""
    display_saves
    puts ""
    puts "Enter the save # of the game you wish to resume:"
    
    input = gets.chomp    
    until input.downcase == "x"
      if input.downcase.match(/\d+/) && input != "0"
        if !saves[input.to_i - 1].nil?
          file_to_load = saves[input.to_i - 1]
          loaded_save = YAML.load(File.read("save/#{file_to_load}"))
          
          board_state = loaded_save[0]
          white_player = loaded_save[1][0]
          black_player = loaded_save[1][1]
          current_player = loaded_save[2]
          
          @board = Board.new(white_player, black_player, board_state, current_player)
          puts current_player
          break
        end
      end
      puts "Invalid save #! Enter a valid save #, or 'x' to exit load screen!"
      input = gets.chomp
    end
  end
  
  def welcome_screen
    system "clear"
    
    puts "\u2659 \u265F " * 17
    puts chess_ascii
    puts "\u2659 \u265F " * 17
    puts ""
    puts "             A game written in Ruby by Andy Holt, 2018"
    puts ""
    puts "                    Press any key to continue!"
    STDIN.getch    
    system "clear"
    puts "Enter a name for white:"
    white_player = gets.chomp
    puts "Enter a name for black:"
    black_player = gets.chomp
    
    @board = Board.new(white_player, black_player)
    @board.new_board
  end
  
  def chess_ascii
    "                                                                
  ,ad8888ba,   88        88  88888888888  ad88888ba    ad88888ba   
 d8\"'    `\"8b  88        88  88          d8\"     \"8b  d8\"     \"8b  
d8'            88        88  88          Y8,          Y8,          
88             88aaaaaaaa88  88aaaaa     `Y8aaaaa,    `Y8aaaaa,    
88             88\"\"\"\"\"\"\"\"88  88\"\"\"\"\"       `\"\"\"\"\"8b,    `\"\"\"\"\"8b,  
Y8,            88        88  88                  `8b          `8b  
 Y8a.    .a8P  88        88  88          Y8a     a8P  Y8a     a8P  
  `\"Y8888Y\"'   88        88  88888888888  \"Y88888P\"    \"Y88888P\"
  "
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
    elsif input.downcase == "save"
      save_game
    elsif input.downcase == "load"
      load_game
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
  
  def game_over_screen
    @board.display
    if @board.stalemate?
      puts "The game has ended in a stalemate!"
    elsif @board.checkmate?
      @board.switch_players
      puts "game over! #{current_player[0]} wins!"
    end
  end
  
end