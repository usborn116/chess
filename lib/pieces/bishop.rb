require_relative 'piece.rb'

# Creates the Bishop Piece with its unique moveset and icon
class Bishop < Piece
  def initialize(position, white)
    @moveset = [
      [1, 1],
      [1, -1],
      [-1, 1],
      [-1, -1]
    ]
    @icon = white ? 'B' : 'b'
    super
  end
end