require_relative 'piece.rb'

# Creates the Queen Piece with its unique moveset and icon
class Queen < Piece
  def initialize(position, white)
    @moveset = [
      [1, 1],
      [1, -1],
      [-1, 1],
      [-1, -1],
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0]
    ]
    @icon = white ? 'Q' : 'q'
    super
  end
end