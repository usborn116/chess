require_relative 'pieces/horse.rb'
require_relative 'player.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/king.rb'
require_relative 'pieces/pawn.rb'
require_relative 'board.rb'
require_relative 'save_load.rb'

class Game
  include SaveLoad
  attr_accessor :positions, :player1, :player2, :turn_counter, :board

  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
    @turn_counter = 0
  end

  def play
    @board.display
    print "Instructions at https://www.chess.com/learn-how-to-play-chess\n\n"
    p "Would you like to load a game? Enter 'y' or 'n'"
    start = gets.chomp.downcase
    if start == 'y'
      game = load_game
      if game
        2.times { puts }
        game.board.display
        game.turns
        return
      end
    end
    create_players
    @board.display
    print "#{@player1}'s soldiers are on the bottom side and will go first!\n\n"
    print "#{@player2}'s soldiers are on the top side and will go second!\n\n\n"
    turns
  end

  def create_players
    @player1 = Player.new(1)
    @player2 = Player.new(2)
  end

  def turns
    update_possible_moves
    until checkmate? == true
      if check?
        check_turn
      else
        a = turn
      end
      if a == 'done'
        return
      end
      @board.display
    end
    puts "Congratulations, #{current_player}! You are the Champion!"
  end

  def current_player
    @turn_counter % 2 == 0 ? @player2 : @player1
  end

  def current_color
    @turn_counter % 2 == 0 ? "black" : "white"
  end

  def turn
    print "It's your turn, #{current_player}! What are you going to do?\n\n"
    print "Enter 's' or 'm' to save the game or make a move\n> "
    input = gets.chomp.downcase
    if input == 's'
      save_game(self)
      return 'done'
    end

    move, piece_position, piece_move_position = nil, nil, nil

    loop do
      move = current_player.get_move
      piece_position = convert([move[2], move[1]])
      piece_move_position = convert([move[4], move[3]])
      piece = @board.positions[piece_position[0]][piece_position[1]]
      break if piece != nil && piece.possible_moves.include?(piece_move_position) && piece.color == current_color
      print "\nHmm.. That doesn't appear to be a valid move. Please try again:\n> "
    end

    move(piece_position, piece_move_position)
    @turn_counter += 1
  end

  def check_turn
    print "Your King is in check, #{current_player}! You better do something!\n> "

    move, piece_position, piece_move_position = nil, nil, nil

    loop do
      move = current_player.get_move
      piece_position = convert([move[2], move[1]])
      piece_move_position = convert([move[4], move[3]])
      piece = @board.positions[piece_position[0]][piece_position[1]]
      break if piece.possible_moves.include?(piece_move_position) && piece.color == current_color && breaks_check?(piece_position, piece_move_position) == true
      print "\nThat still leaves your King in check. Try again:\n> "
    end

    move(piece_position, piece_move_position)
  end

  def breaks_check?(current, new)
    breaks_check = false
    cache = Board.clone(@board.positions)

    move(current, new)
    @board.positions.flatten.select { |square| !square.nil? && square.instance_of?(King) && square.color == current_color }.each do |king|
      breaks_check = true if king.in_check?(@board.positions) == false
    end
    @board.positions = cache
    update_possible_moves
    breaks_check
  end

  def convert(array)
    array[0] = 7 - (array[0].to_i - 1)
    array[1] = array[1].ord - 97
    array
  end

  def update_possible_moves
    @board.positions.flatten.each do |piece|
      piece&.find_possible_moves(@board.positions) unless piece.instance_of?(King)
    end
    @board.positions.flatten.each do |piece|
      piece&.find_possible_moves(@board.positions) if piece.instance_of?(King)
    end
  end

  def move(current, new)
    double_stepped = check_for_double_step(current, new) 

    if en_passant?(current, new) 
      @board.positions[current[0]][new[1]] = nil
    end

    if castle?(current, new)
      case new
      when [7, 2]
        temp = @board.positions[7][0]
        @board.positions[7][0] = nil
        @board.positions[7][3] = temp
        temp.x = 7
        temp.y = 3
      when [7, 6]
        temp = @board.positions[7][7]
        @board.positions[7][7] = nil
        @board.positions[7][5] = temp
        temp.x = 7
        temp.y = 5
      when [0, 2]
        temp = @board.positions[0][0]
        @board.positions[0][0] = nil
        @board.positions[0][3] = temp
        temp.x = 0
        temp.y = 3
      when [0, 6]
        temp = @board.positions[0][7]
        @board.positions[0][7] = nil
        @board.positions[0][5] = temp
        temp.x = 0
        temp.y = 5
      end
    end
    temp = @board.positions[current[0]][current[1]]
    if temp != nil
      temp.x = new[0]
      temp.y = new[1]
    end
      
    @board.positions[current[0]][current[1]] = nil
    @board.positions[new[0]][new[1]] = temp

    temp.has_moved = true if temp.instance_of?(King) || temp.instance_of?(Rook) || temp.instance_of?(Pawn)

    if temp.instance_of?(Pawn)
      temp.double_stepped = false if temp.double_stepped == true
      temp.double_stepped = true if double_stepped
    end

    promote_pawn = promote?
    promote(promote_pawn) if !promote_pawn.nil?
    update_possible_moves
  end

  def check_for_double_step(current, new)
    piece = @board.positions[current[0]][current[1]]
    if piece.instance_of?(Pawn) && (piece.x - new[0]).abs == 2
      return true
    end
    false
  end

  def castle?(current, new)
    castle_moves = [[7, 2], [7, 6], [0, 2], [0, 6]]
    piece = @board.positions[current[0]][current[1]]
    if piece.instance_of?(King) && piece.has_moved == false && castle_moves.include?(new)
      return true
    end
    false
  end

  def en_passant?(current, new) 
    piece = @board.positions[current[0]][current[1]]

    if piece.instance_of?(Pawn) && @board.positions[new[0]][new[1]].nil? && current[1] != new[1]
      return true
    end
    false
  end

  def promote?
    promote_pawn = nil
    (0..7).each do |x|
      promote_pawn = @board.positions[0][x] if @board.positions[0][x].instance_of?(Pawn)
      promote_pawn = @board.positions[7][x] if @board.positions[7][x].instance_of?(Pawn)
    end
    promote_pawn
  end

  def promote(pawn)
    acceptable_input = ["queen", "knight", "rook", "bishop"]
    p "\nYour Pawn has reached the end of the board, #{current_player}!\n\n"
    p "You can promote your Pawn into a Queen, Knight, Rook, or Bishop. Please input which:\n> "
    promotion = gets.chomp.downcase

    until acceptable_input.include?(promotion)
      p "\n That doesn't appear to be something you can promote a pawn to.. Try again:\n> "
      promotion = gets.chomp.downcase
    end

    case promotion
    when "queen"
      @board.positions[pawn.x][pawn.y] = Queen.new([pawn.x, pawn.y], pawn.color)
    when "knight"
      @board.positions[pawn.x][pawn.y] = Knight.new([pawn.x, pawn.y], pawn.color)
    when "rook"
      @board.positions[pawn.x][pawn.y] = Rook.new([pawn.x, pawn.y], pawn.color)
    when "bishop"
      @board.positions[pawn.x][pawn.y] = Bishop.new([pawn.x, pawn.y], pawn.color)
    end
  end

  def check?
    @board.positions.flatten.select { |square| square.instance_of?(King) && square.color == current_color }.each do |king|
      if king.in_check?(@board.positions)
        return true
      end
    end
    false
  end

  def checkmate?
    @turn_counter += 1
    @board.positions.flatten.select {|square| square.instance_of?(King) && square.color == current_color }.each do |king|
      return false if !king.in_check?(@board.positions)
      return false if any_breaks_checks? == true
      return false if !king.possible_moves.empty?
    end
    true
  end

  def any_breaks_checks?
    @board.positions.flatten.select { |square| !square.nil? && square.color == current_color }.each do |piece|
      piece.possible_moves.each do |move|
        if breaks_check?([piece.x, piece.y], move)
          return true
        end
      end
    end
    false
  end
end