require_relative './save_load.rb'
require_relative './game.rb'

class Player
    def initialize(number)
      @name = get_name(number)
    end
  
    def to_s
      @name
    end
  
    def get_name(number)
      print "Hello Player #{number}! What is your name?\n> "
      @name = gets.chomp
      @name
    end
  
    def get_move
      move = input
      until move_format =~ move
        print "\nThat doesn't appear to be in the correct format. Remember: [Letter][Number] to [Letter][Number] (example: B2 to B4).\n> "
        move = input
      end
      p move_format.match(move)
    end
  
    private
  
    def move_format
      /^([a-h])([1-8])\s{1}to\s{1}([a-h])([1-8])$/
    end
  
    def input
      p "What is your move?"
      gets.chomp.downcase
    end
  end

