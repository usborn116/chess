require_relative 'piece.rb'

# Creates the Rook Piece with its unique moveset and icon
# and tracking of whether it has moved.
class Rook < Piece
  attr_accessor :has_moved

  def initialize(position, white)
    @moveset = [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0]
    ]
    @has_moved = false
    @icon = white ? 'R' : 'r'
    super
  end
end