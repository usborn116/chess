class Piece
  attr_accessor :moveset, :x, :y, :icon, :possible_moves, :color
  
  def initialize(start_pos, white)
    @x = start_pos[0]
    @y = start_pos[1]
    @color = white ? 'white' : 'black'
    @possible_moves = []
  end

  def find_possible_moves(positions)
    @possible_moves = []

    @moveset.each do |move|
      x = @x + move[0]
      y = @y + move[1]

      loop do
        break if Board.includes?(x, y) == false
        @possible_moves << [x, y] if positions[x][y].nil? || positions[x][y].color != @color
        break if !positions[x][y].nil?
        x += move[0]
        y += move[1]
      end
    end
  end
end
