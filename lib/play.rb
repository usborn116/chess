require_relative 'pieces/horse.rb'
require_relative 'player.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/king.rb'
require_relative 'pieces/pawn.rb'
require_relative 'pieces/piece.rb'
require_relative 'board.rb'
require_relative "game.rb"
require_relative "player.rb"

Game.new.play
