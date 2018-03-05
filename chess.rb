Dir["./lib/*.rb"].each {|file| require file}

chess = Game.new
chess.play