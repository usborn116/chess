require_relative '../board.rb'

# Creates the King Piece with its unique moveset, 
# moveset calculation algorithms, and icon
class King < Piece
  attr_accessor :has_moved

  def initialize(position, white)
    @moveset = [
      [1, 1],
      [1, 0],
      [1, -1],
      [0, 1],
      [0, -1],
      [-1, 1],
      [-1, 0],
      [-1, -1]
    ]
    @icon = white ? 'K' : 'k'
    @has_moved = false
    super
  end

  def find_possible_moves(positions)
    @possible_moves = []

    @moveset.each do |move|
      x = @x + move[0]
      y = @y + move[1]

      if Board.includes?(x, y)

        test_positions = Board.clone(positions)

        test_positions[@x][@y] = nil
        test_king = King.new([x, y], @color == "white")
        test_positions[x][y] = test_king

        test_positions.flatten.select { |square| square !=  nil && square.color != color }.each do |piece| 
          if piece.instance_of?(King)
            piece.moveset.each do |test_move|
              a = piece.x + test_move[0]
              b = piece.y + test_move[1]

              if Board.includes?(a, b)
                piece.possible_moves << [a, b]
              end
            end
          else
            piece.find_possible_moves(test_positions)
          end
        end
        
        @possible_moves << [x, y] if !test_king.in_check?(test_positions) && (positions[x][y].nil? || positions[x][y].color != @color)
      end
    end
    check_for_castle(positions) if @has_moved == false
  end

  def in_check?(positions)
    in_check = false
    positions.flatten.select { |piece| !piece.nil? && piece.color != @color }.each do |piece|
      if piece.instance_of? Pawn
        piece.possible_moves.each do |move|
          in_check = true if move[1] != piece.y && move == [@x, @y]
        end
      else
        in_check = true if piece.possible_moves.include?([@x, @y]) 
      end
    end

    in_check
  end

  def check_for_castle(positions)
    x = @color == "white" ? 7 : 0

    if positions[x][0].instance_of?(Rook) && positions[x][0]&.has_moved == false 
      if positions[x][1].nil? && positions[x][2].nil? && positions[x][3].nil?
        valid = true
        positions.flatten.select { |square| !square.nil? && square.color != @color }.each do |piece|
          valid = false if piece.possible_moves.include?([x, 2])
        end
        @possible_moves << [x, 2] if valid
      end
    end

    if positions[x][7].instance_of?(Rook) && positions[x][7]&.has_moved == false
      if positions[x][5].nil? && positions[x][6].nil?
        valid = true
        positions.flatten.select { |square| !square.nil? && square.color != @color }.each do |piece|
          valid = false if piece.possible_moves.include?([x, 6])
        end
        @possible_moves << [x, 6] if valid
      end
    end
  end
end
